# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

"""A tiny HTTP service whose every request runs the actions in $ACTIONS, separated by `;`:

  http:<url>                       GET the URL (requests)
  pg:<host>:<port>                 SELECT 1 on PostgreSQL (psycopg2)
  redis:<host>:<port>              GET a key on Redis (redis-py)
  kafka:<bootstrap>|<topic>        produce one message (confluent-kafka)
  amqp:<host>:<port>|<queue>       publish one message (pika)

Headers listed in $FORWARD_HEADERS are passed on to the http: calls.
"""
import os

import psycopg2
import redis
import requests
from confluent_kafka import Producer
from flask import Flask, request

import pika

app = Flask(__name__)
ACTIONS = [a for a in os.environ.get("ACTIONS", "").split(";") if a]
FORWARD = [h for h in os.environ.get("FORWARD_HEADERS", "").split(",") if h]
_producers = {}
_amqp = {}


def kafka_producer(bootstrap):
    if bootstrap not in _producers:
        _producers[bootstrap] = Producer({"bootstrap.servers": bootstrap})
    return _producers[bootstrap]


def amqp_channel(host, port, queue):
    key = (host, port)
    if key not in _amqp:
        conn = pika.BlockingConnection(pika.ConnectionParameters(host=host, port=int(port)))
        channel = conn.channel()
        channel.queue_declare(queue=queue)
        _amqp[key] = channel
    return _amqp[key]


def run(action):
    kind, _, target = action.partition(":")
    if kind == "http":
        headers = {h: request.headers[h] for h in FORWARD if h in request.headers}
        requests.get(target, headers=headers, timeout=5)
    elif kind == "pg":
        host, port = target.split(":")
        with psycopg2.connect(host=host, port=port, user="shop", password="shop", dbname="orders") as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
    elif kind == "redis":
        host, port = target.split(":")
        redis.Redis(host=host, port=int(port)).get("session")
    elif kind == "kafka":
        bootstrap, topic = target.split("|")
        producer = kafka_producer(bootstrap)
        producer.produce(topic, b"hello")
        producer.flush(5)
    elif kind == "amqp":
        address, queue = target.split("|")
        host, port = address.rsplit(":", 1)
        amqp_channel(host, port, queue).basic_publish(exchange="", routing_key=queue, body=b"hello")


@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def handle(path):
    for action in ACTIONS:
        try:
            run(action)
        except Exception as e:  # keep serving; the span records the error
            app.logger.warning("%s failed: %s", action, e)
    return "ok\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, threaded=True)
