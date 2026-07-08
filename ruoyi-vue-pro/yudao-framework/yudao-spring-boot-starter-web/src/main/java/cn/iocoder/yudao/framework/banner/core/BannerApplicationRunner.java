package cn.iocoder.yudao.framework.banner.core;

import cn.hutool.core.thread.ThreadUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;

import java.util.concurrent.TimeUnit;

/**
 * 项目启动成功后，提供文档相关的地址
 *
 * @author mall-base
 */
@Slf4j
public class BannerApplicationRunner implements ApplicationRunner {

    @Override
    public void run(ApplicationArguments args) {
        ThreadUtil.execute(() -> {
            ThreadUtil.sleep(1, TimeUnit.SECONDS); // 延迟 1 秒，保证输出到结尾
            log.info("\n----------------------------------------------------------\n\t" +
                            "商城底座后端启动成功！\n\t" +
                            "接口文档: \t{} \n\t" +
                            "管理端: \t{} \n\t" +
                            "移动端: \t{} \n" +
                            "----------------------------------------------------------",
                    "http://127.0.0.1:48080/swagger-ui",
                    "http://127.0.0.1:81",
                    "http://127.0.0.1:3000");
        });
    }

}
