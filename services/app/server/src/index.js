/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */
const express = require('express');
const axios = require('axios');
const { default: agent } = require('skywalking-backend-js');
const agentName = process.env.SW_AGENT_NAME_SERVER || 'agent::app'

// @feature: nodejs-agent-backend;
agent.start({
    serviceName: agentName,
    maxBufferSize: 1000,
    traceIgnorePath: '/health',
});

const PORT = process.env.PORT || 80;
const GATEWAY = process.env.GATEWAY || 'gateway';

const app = express();

app.get('/homepage', async (req, res) => {
    const top = await axios.get(`http://${GATEWAY}/songs/top`);
    const rcmd = await axios.get(`http://${GATEWAY}/rcmd`);

    res.json({
        top: top.data,
        rcmd: rcmd.data,
    });
});

app.get('/health', async (req, res) => {
    res.json({healthy: true});
});

app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`);
});
