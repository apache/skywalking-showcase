/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.apache.skywalking.showcase.services.song.controller;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.skywalking.showcase.services.song.entity.Song;
import org.apache.skywalking.showcase.services.song.repo.SongsRepo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/songs")
public class SongController {
    private final SongsRepo songsRepo;

    private final Cache<String, String> guavaCache = CacheBuilder.newBuilder()
                                                                 .concurrencyLevel(
                                                                     Runtime.getRuntime().availableProcessors())
                                                                 .build();

    @GetMapping
    public List<Song> songs() {
        log.info("Listing all songs");
        List<Song> songs = songsRepo.findAll();
        saveCache(songs);
        return songs;
    }

    @GetMapping("/top")
    public List<Song> top() {
        log.info("Listing top songs");
        return songsRepo.findByLikedGreaterThan(1000);
    }

    private void saveCache(final List<Song> songs) {
        for (Song song : songs) {
            String key = "song_" + song.getId();
            guavaCache.put(key, String.format("%s,%s,%s", song.getName(), song.getArtist(), song.getGenre()));
            guavaCache.getIfPresent(key);
            guavaCache.invalidate(key);
        }
    }
}
