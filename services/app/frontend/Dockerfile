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

FROM node:10 AS build

ARG SW_AGENT_NODEJS_FRONTEND_VERSION

WORKDIR /skywalking-client-js

RUN git clone --recurse-submodules https://github.com/apache/skywalking-client-js.git . ; \
    git reset --hard ${SW_AGENT_NODEJS_FRONTEND_VERSION} ; \
    git submodule update ; \
    git submodule sync ; \
    npm install ; \
    npm run build

WORKDIR /app

COPY . .

RUN npm install /skywalking-client-js && \
    npm install && \
    npm run build

FROM apache/apisix:2.15.0-debian

ENV SW_AGENT_SERVICE=agent::frontend
ENV SW_AGENT_SERVICE_INSTANCE=agent::frontend-instance

COPY --from=build /app/build /app/build
