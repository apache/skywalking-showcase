
FROM node:10

ARG SW_NODEJS_BACKEND_VERSION

WORKDIR /skywalking-nodejs-backend

RUN git clone --recurse-submodules https://github.com/apache/skywalking-nodejs.git . ; \
    git reset --hard ${SW_NODEJS_BACKEND_VERSION} ; \
    npm install ; \
    npm run build

WORKDIR /skywalking-nodejs-frontend

RUN git clone --recurse-submodules https://github.com/apache/skywalking-client-js.git . ; \
    git reset --hard ${SW_NODEJS_FRONTEND_VERSION} ; \
    npm install ; \
    npm run build

WORKDIR /app

COPY . .

RUN npm install /skywalking-nodejs-backend ; \
    npm install /skywalking-nodejs-frontend ; \
    npm run build

CMD npm start
