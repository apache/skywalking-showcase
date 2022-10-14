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
import './App.css';

function App() {
    const [data, setData] = React.useState(null);

    React.useEffect(() => {
        fetch("/homepage")
            .then((res) => res.json())
            .then((data) => setData(JSON.stringify(data)));
        // mock app server error
        const xhr = new XMLHttpRequest();
        xhr.open('post', '/test');
        xhr.send();    
        // mock apisix error
        const apisix = new XMLHttpRequest();
        apisix.open('post', '/test-apisix-404');
        apisix.send();
}, []);

    return (
        <div className="App">
            <p>{!data ? "Loading..." : data}</p>
        </div>
    );
}

export default App;
