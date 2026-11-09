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
FROM python:3.12-slim

RUN pip install --no-cache-dir \
      flask requests psycopg2-binary redis confluent-kafka pika \
      opentelemetry-distro==0.66b2 opentelemetry-exporter-otlp-proto-grpc==1.45.2 \
 && opentelemetry-bootstrap -a install

WORKDIR /app
COPY web.py consumer.py ./

ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://oap:11800 \
    OTEL_EXPORTER_OTLP_PROTOCOL=grpc \
    OTEL_TRACES_EXPORTER=otlp \
    OTEL_METRICS_EXPORTER=none \
    OTEL_LOGS_EXPORTER=none \
    OTEL_BSP_SCHEDULE_DELAY=1000 \
    PYTHONUNBUFFERED=1

CMD ["opentelemetry-instrument", "python", "web.py"]
