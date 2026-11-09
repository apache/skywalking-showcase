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

"""Consume forever from $SOURCE:

  kafka:<bootstrap>|<topic>|<group>   confluent-kafka
  amqp:<host>:<port>|<queue>          pika, basic_consume callbacks
"""
import os
import time

from confluent_kafka import Consumer

import pika

kind, _, target = os.environ["SOURCE"].partition(":")

while True:
    try:
        if kind == "kafka":
            bootstrap, topic, group = target.split("|")
            consumer = Consumer({"bootstrap.servers": bootstrap, "group.id": group,
                                 "auto.offset.reset": "latest"})
            consumer.subscribe([topic])
            while True:
                consumer.poll(1.0)
        elif kind == "amqp":
            address, queue = target.split("|")
            host, port = address.rsplit(":", 1)
            conn = pika.BlockingConnection(pika.ConnectionParameters(host=host, port=int(port)))
            channel = conn.channel()
            channel.queue_declare(queue=queue)
            channel.basic_consume(queue=queue, on_message_callback=lambda ch, m, p, b: None, auto_ack=True)
            channel.start_consuming()
    except Exception as e:  # the broker may not be up yet
        print(f"consumer: {e}", flush=True)
        time.sleep(3)
