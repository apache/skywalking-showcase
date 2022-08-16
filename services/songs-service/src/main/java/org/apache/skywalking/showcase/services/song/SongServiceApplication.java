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

package org.apache.skywalking.showcase.services.song;

import org.apache.skywalking.apm.meter.micrometer.SkywalkingConfig;
import org.apache.skywalking.apm.meter.micrometer.SkywalkingMeterRegistry;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;

@SpringBootApplication
public class SongServiceApplication {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplateBuilder()
            .rootUri("http://gateway")
            .build();
    }

    @Bean
    SkywalkingMeterRegistry skywalkingMeterRegistry() {
        SkywalkingConfig config = new SkywalkingConfig(Arrays.asList(""));
        return new SkywalkingMeterRegistry(config);
    }

    public static void main(String[] args) {
        SpringApplication.run(SongServiceApplication.class, args);
    }

}
