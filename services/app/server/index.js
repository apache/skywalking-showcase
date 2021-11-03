const path = require('path');
const express = require('express');
const axios = require('axios');
const {default: agent} = require('skywalking-backend-js');

agent.start({
    serviceName: 'app',
    maxBufferSize: 1000,
});

const PORT = process.env.PORT || 80;

const app = express();

app.use(express.static(path.resolve(__dirname, '../ui/build')));

app.get("/homepage", async (req, res) => {
    const top = await axios.get('http://gateway/songs/top');
    const rcmd = await axios.get('http://gateway/rcmd');

    res.json({
        top: top.data,
        rcmd: rcmd.data,
    });
});

app.get("/health", async (req, res) => {
    res.json({ healthy: true });
});

app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../ui/build', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`);
});
