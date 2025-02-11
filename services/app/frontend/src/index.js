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
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

// @feature: nodejs-agent-frontend;
import ClientMonitor from 'skywalking-client-js';

const agentName = process.env.REACT_APP_SW_AGENT_NAME_UI || 'agent::ui'

ClientMonitor.register({
    service: agentName,
    pagePath: '/homepage',
    serviceVersion: 'v1.0.0',
    useWebVitals: true,
    traceTimeInterval: 2000,
});

// promise error
function foo() {
    Promise.reject({
        message: 'promise test',
        stack: 'promise error'
    });
  }
foo();
function timeout() {
    return new Promise((resolve, reject) => {
        setTimeout(() => Math.random() > 0.5 ?
        resolve() :
        reject({
            message: 'timeout test',
            stack: 2000
        }), 500)
    })
}
timeout();

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
        <App />
  </React.StrictMode>
);
