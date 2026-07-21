package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Accessors(chain = true)
public class AiLogisticsTrackRespVO {

    private Long orderId;
    private String orderNo;
    private String logisticsName;
    private String logisticsNo;
    private List<TrackItem> tracks;

    @Data
    @Accessors(chain = true)
    public static class TrackItem {
        private LocalDateTime time;
        private String content;
    }

}