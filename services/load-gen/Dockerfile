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
FROM selenium/standalone-chrome:97.0-20250202

WORKDIR /home/seluser

COPY requirements.txt requirements.txt
COPY loadgen.py loadgen.py

RUN sudo apt-get update && sudo apt-get install -y python3-pip python3-venv
RUN sudo python3 -m venv python && sudo ./python/bin/pip3 install -r requirements.txt

CMD python/bin/python3 -u loadgen.py
