package org.apache.skywalking.showcase.services.song.vo;

import java.util.List;
import lombok.Data;
import org.apache.skywalking.showcase.services.song.entity.Song;

@Data
public class TrendingList {
    private final List<Song> top;
    private final List<Song> recommendations;
}
