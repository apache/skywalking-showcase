import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';

import ClientMonitor from 'skywalking-client-js';

ClientMonitor.register({
    collector: 'http://oap:12800',
    service: 'ui',
    pagePath: '/homepage',
    serviceVersion: 'v1.0.0',
});

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
