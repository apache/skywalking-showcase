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

package org.apache.skywalking.showcase.services.song.controller;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.Session;
import javax.jms.TextMessage;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SongMessageReceiver {
    @Value("${ACTIVE_MQ_URL:tcp://127.0.0.1:61616}")
    private String activeMQUrl;
    @Value("${ACTIVE_MQ_USER:user}")
    private String activeMQUser;
    @Value("${ACTIVE_MQ_PASSWORD:password}")
    private String activeMQPassword;
    @Value("${ACTIVE_MQ_QUEUE:queue}")
    private String activeMQQueue;

    private Session session;

    private MessageConsumer messageConsumer;

    private Connection connection;

    @PostConstruct
    public void initMQSource() {
        try {
            ConnectionFactory factory = new ActiveMQConnectionFactory(activeMQUrl);
            connection = factory.createConnection();
            connection.start();
            session = connection.createSession(Boolean.TRUE, Session.AUTO_ACKNOWLEDGE);
            Destination destination = session.createQueue(activeMQQueue);
            messageConsumer = session.createConsumer(destination);
            new Thread(this::receiveMsg).start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void receiveMsg() {
        try {
            final Message message = messageConsumer.receive();
            System.out.println("receive msg : " + ((TextMessage) message).getText());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @PreDestroy
    public void releaseMQSource() {
        try {
            if (this.messageConsumer != null) {
                this.messageConsumer.close();
            }
            if (this.session != null) {
                this.session.close();
            }
            if (this.connection != null) {
                connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
