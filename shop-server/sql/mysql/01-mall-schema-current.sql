-- Generated from current mall/member/pay Java DO classes.
-- Regenerate with: node scripts/generate-mall-schema.js
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `member_address`;
CREATE TABLE `member_address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '收件人名称',
  `mobile` varchar(1024) DEFAULT NULL COMMENT '手机号',
  `area_id` bigint DEFAULT NULL COMMENT '地区编号',
  `detail_address` varchar(1024) DEFAULT NULL COMMENT '收件详细地址',
  `default_status` bit(1) DEFAULT NULL COMMENT '是否默认 true - 默认收件地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户收件地址';

DROP TABLE IF EXISTS `member_config`;
CREATE TABLE `member_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `point_trade_deduct_enable` bit(1) DEFAULT NULL COMMENT '积分抵扣开关',
  `point_trade_deduct_unit_price` int DEFAULT NULL COMMENT '积分抵扣，单位：分 1 积分抵扣多少分',
  `point_trade_deduct_max_price` int DEFAULT NULL COMMENT '积分抵扣最大值',
  `point_trade_give_point` int DEFAULT NULL COMMENT '1 元赠送多少分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员配置';

DROP TABLE IF EXISTS `member_experience_record`;
CREATE TABLE `member_experience_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 {@link MemberUserDO#getId()} 字段',
  `biz_type` int DEFAULT NULL COMMENT '业务类型 <p> 枚举 {@link MemberExperienceBizTypeEnum}',
  `biz_id` varchar(1024) DEFAULT NULL COMMENT '业务编号',
  `title` varchar(1024) DEFAULT NULL COMMENT '标题',
  `description` longtext DEFAULT NULL COMMENT '描述',
  `experience` int DEFAULT NULL COMMENT '经验',
  `total_experience` int DEFAULT NULL COMMENT '变更后的经验',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员经验记录';

DROP TABLE IF EXISTS `member_group`;
CREATE TABLE `member_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '名称',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `status` int DEFAULT NULL COMMENT '状态 <p> 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户分组';

DROP TABLE IF EXISTS `member_level`;
CREATE TABLE `member_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '等级名称',
  `level` int DEFAULT NULL COMMENT '等级',
  `experience` int DEFAULT NULL COMMENT '升级经验',
  `discount_percent` int DEFAULT NULL COMMENT '享受折扣',
  `icon` varchar(1024) DEFAULT NULL COMMENT '等级图标',
  `background_url` varchar(1024) DEFAULT NULL COMMENT '等级背景图',
  `status` int DEFAULT NULL COMMENT '状态 <p> 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员等级 DO 配置每个等级需要的积分';

DROP TABLE IF EXISTS `member_level_record`;
CREATE TABLE `member_level_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 {@link MemberUserDO#getId()} 字段',
  `level_id` bigint DEFAULT NULL COMMENT '等级编号 关联 {@link MemberLevelDO#getId()} 字段',
  `level` int DEFAULT NULL COMMENT '会员等级 冗余 {@link MemberLevelDO#getLevel()} 字段',
  `discount_percent` int DEFAULT NULL COMMENT '享受折扣',
  `experience` int DEFAULT NULL COMMENT '升级经验',
  `user_experience` int DEFAULT NULL COMMENT '会员此时的经验',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `description` longtext DEFAULT NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员等级记录 DO 用户每次等级发生变更时，记录一条日志';

DROP TABLE IF EXISTS `member_point_record`;
CREATE TABLE `member_point_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 对应 MemberUserDO 的 id 属性',
  `biz_id` varchar(1024) DEFAULT NULL COMMENT '业务编码',
  `biz_type` int DEFAULT NULL COMMENT '业务类型 枚举 {@link MemberPointBizTypeEnum}',
  `title` varchar(1024) DEFAULT NULL COMMENT '积分标题',
  `description` longtext DEFAULT NULL COMMENT '积分描述',
  `point` int DEFAULT NULL COMMENT '变动积分 1、正数表示获得积分 2、负数表示消耗积分',
  `total_point` int DEFAULT NULL COMMENT '变动后的积分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户积分记录';

DROP TABLE IF EXISTS `member_sign_in_config`;
CREATE TABLE `member_sign_in_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则自增主键',
  `day` int DEFAULT NULL COMMENT '签到第 x 天',
  `point` int DEFAULT NULL COMMENT '奖励积分',
  `experience` int DEFAULT NULL COMMENT '奖励经验',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到规则';

DROP TABLE IF EXISTS `member_sign_in_record`;
CREATE TABLE `member_sign_in_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '签到用户',
  `day` int DEFAULT NULL COMMENT '第几天签到',
  `point` int DEFAULT NULL COMMENT '签到的积分',
  `experience` int DEFAULT NULL COMMENT '签到的经验',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到记录';

DROP TABLE IF EXISTS `member_tag`;
CREATE TABLE `member_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '标签名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员标签';

DROP TABLE IF EXISTS `member_user`;
CREATE TABLE `member_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `mobile` varchar(1024) DEFAULT NULL COMMENT '手机',
  `email` varchar(1024) DEFAULT NULL COMMENT '邮箱',
  `password` varchar(1024) DEFAULT NULL COMMENT '加密后的密码 因为目前使用 {@link BCryptPasswordEncoder} 加密器，所以无需自己处理 salt 盐',
  `status` int DEFAULT NULL COMMENT '帐号状态 枚举 {@link CommonStatusEnum}',
  `register_ip` varchar(1024) DEFAULT NULL COMMENT '注册 IP',
  `register_terminal` int DEFAULT NULL COMMENT '注册终端 枚举 {@link TerminalEnum}',
  `login_ip` varchar(1024) DEFAULT NULL COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `nickname` varchar(1024) DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(1024) DEFAULT NULL COMMENT '用户头像',
  `name` varchar(1024) DEFAULT NULL COMMENT '真实名字',
  `sex` int DEFAULT NULL COMMENT '性别 枚举 {@link SexEnum}',
  `birthday` datetime DEFAULT NULL COMMENT '出生日期',
  `area_id` int DEFAULT NULL COMMENT '所在地 关联 {@link Area#getId()} 字段',
  `mark` varchar(1024) DEFAULT NULL COMMENT '用户备注',
  `point` int DEFAULT NULL COMMENT '积分',
  `tag_ids` longtext DEFAULT NULL COMMENT '会员标签列表，以逗号分隔',
  `level_id` bigint DEFAULT NULL COMMENT '会员级别编号 关联 {@link MemberLevelDO#getId()} 字段',
  `experience` int DEFAULT NULL COMMENT '会员经验',
  `group_id` bigint DEFAULT NULL COMMENT '用户分组编号 关联 {@link MemberGroupDO#getId()} 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员用户 DO uk_mobile 索引：基于 {@link #mobile} 字段';

DROP TABLE IF EXISTS `pay_app`;
CREATE TABLE `pay_app` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '应用编号，数据库自增',
  `app_key` varchar(1024) DEFAULT NULL COMMENT '应用标识',
  `name` varchar(1024) DEFAULT NULL COMMENT '应用名',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `order_notify_url` varchar(1024) DEFAULT NULL COMMENT '支付结果的回调地址',
  `refund_notify_url` varchar(1024) DEFAULT NULL COMMENT '退款结果的回调地址',
  `transfer_notify_url` varchar(1024) DEFAULT NULL COMMENT '转账结果的回调地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付应用 DO 一个商户下，可能会有多个支付应用。例如说，京东有京东商城、京东到家等等 不过一般来说，一个商户，只有一个应用哈~ 即 PayMerchantDO : PayAppDO = 1 : n';

DROP TABLE IF EXISTS `pay_channel`;
CREATE TABLE `pay_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '渠道编号，数据库自增',
  `code` varchar(1024) DEFAULT NULL COMMENT '渠道编码 枚举 {@link PayChannelEnum}',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `fee_rate` double DEFAULT NULL COMMENT '渠道费率，单位：百分比',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `app_id` bigint DEFAULT NULL COMMENT '应用编号 关联 {@link PayAppDO#getId()}',
  `config` longtext DEFAULT NULL COMMENT '支付渠道配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付渠道 DO 一个应用下，会有多种支付渠道，例如说微信支付、支付宝支付等等 即 PayAppDO : PayChannelDO = 1 : n';

DROP TABLE IF EXISTS `pay_demo_order`;
CREATE TABLE `pay_demo_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号，自增',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `spu_id` bigint DEFAULT NULL COMMENT '商品编号',
  `spu_name` varchar(1024) DEFAULT NULL COMMENT '商品名称',
  `price` int DEFAULT NULL COMMENT '价格，单位：分',
  `pay_status` bit(1) DEFAULT NULL COMMENT '是否支付',
  `pay_order_id` bigint DEFAULT NULL COMMENT '支付订单编号 对接 pay-module-biz 支付服务的支付订单编号，即 PayOrderDO 的 id 编号',
  `pay_time` datetime DEFAULT NULL COMMENT '付款时间',
  `pay_channel_code` varchar(1024) DEFAULT NULL COMMENT '支付渠道 对应 PayChannelEnum 枚举',
  `pay_refund_id` bigint DEFAULT NULL COMMENT '支付退款单号',
  `refund_price` int DEFAULT NULL COMMENT '退款金额，单位：分',
  `refund_time` datetime DEFAULT NULL COMMENT '退款完成时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='示例订单 演示业务系统的订单，如何接入 pay 系统的支付与退款';

DROP TABLE IF EXISTS `pay_demo_withdraw`;
CREATE TABLE `pay_demo_withdraw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现单编号，自增',
  `subject` varchar(1024) DEFAULT NULL COMMENT '提现标题',
  `price` int DEFAULT NULL COMMENT '提现金额，单位：分',
  `user_account` varchar(1024) DEFAULT NULL COMMENT '收款人账号',
  `user_name` varchar(1024) DEFAULT NULL COMMENT '收款人姓名',
  `type` int DEFAULT NULL COMMENT '提现方式 枚举 {@link PayDemoWithdrawTypeEnum}',
  `status` int DEFAULT NULL COMMENT '提现状态 枚举 {@link PayDemoWithdrawStatusEnum}',
  `pay_transfer_id` bigint DEFAULT NULL COMMENT '转账单编号 关联 {@link PayTransferDO#getId()}',
  `transfer_channel_code` varchar(1024) DEFAULT NULL COMMENT '转账渠道 枚举 {@link cn.iocoder.yudao.module.pay.enums.PayChannelEnum}',
  `transfer_time` datetime DEFAULT NULL COMMENT '转账成功时间',
  `transfer_error_msg` varchar(1024) DEFAULT NULL COMMENT '转账错误提示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='示例提现订单 演示业务系统的转账业务';

DROP TABLE IF EXISTS `pay_notify_log`;
CREATE TABLE `pay_notify_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号，自增',
  `task_id` bigint DEFAULT NULL COMMENT '通知任务编号 关联 {@link PayNotifyTaskDO#getId()}',
  `notify_times` int DEFAULT NULL COMMENT '第几次被通知 对应到 {@link PayNotifyTaskDO#getNotifyTimes()}',
  `response` varchar(1024) DEFAULT NULL COMMENT 'HTTP 响应结果',
  `status` int DEFAULT NULL COMMENT '支付通知状态 枚举 {@link PayNotifyStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商户支付、退款等的通知 Log 每次通知时，都会在该表中，记录一次 Log，方便排查问题';

DROP TABLE IF EXISTS `pay_notify_task`;
CREATE TABLE `pay_notify_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `app_id` bigint DEFAULT NULL COMMENT '应用编号 关联 {@link PayAppDO#getId()}',
  `type` int DEFAULT NULL COMMENT '通知类型 枚举 {@link PayNotifyTypeEnum}',
  `data_id` bigint DEFAULT NULL COMMENT '数据编号，根据不同 type 进行关联： 1. {@link PayNotifyTypeEnum#ORDER} 时，关联 {@link PayOrderDO#getId()} 2. {@link PayNotifyTypeEnum#REFUND} 时，关联 {@link PayRefundDO#getId()} 3. {@link PayNotifyTypeEnum#TRANSFER} 时，关联 {@link PayTransferDO#getId()}',
  `merchant_order_id` varchar(1024) DEFAULT NULL COMMENT '商户订单编号',
  `merchant_refund_id` varchar(1024) DEFAULT NULL COMMENT '商户退款编号',
  `merchant_transfer_id` varchar(1024) DEFAULT NULL COMMENT '商户转账编号',
  `status` int DEFAULT NULL COMMENT '通知状态 枚举 {@link PayNotifyStatusEnum}',
  `next_notify_time` datetime DEFAULT NULL COMMENT '下一次通知时间',
  `last_execute_time` datetime DEFAULT NULL COMMENT '最后一次执行时间',
  `notify_times` int DEFAULT NULL COMMENT '当前通知次数',
  `max_notify_times` int DEFAULT NULL COMMENT '最大可通知次数',
  `notify_url` varchar(1024) DEFAULT NULL COMMENT '通知地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付通知 在支付系统收到支付渠道的支付、退款的结果后，需要不断的通知到业务系统，直到成功。';

DROP TABLE IF EXISTS `pay_order`;
CREATE TABLE `pay_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号，数据库自增',
  `app_id` bigint DEFAULT NULL COMMENT '应用编号 关联 {@link PayAppDO#getId()}',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道编号 关联 {@link PayChannelDO#getId()}',
  `channel_code` varchar(1024) DEFAULT NULL COMMENT '渠道编码 枚举 {@link PayChannelEnum}',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `user_type` int DEFAULT NULL COMMENT '用户类型',
  `merchant_order_id` varchar(1024) DEFAULT NULL COMMENT '商户订单编号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `subject` varchar(1024) DEFAULT NULL COMMENT '商品标题',
  `body` varchar(1024) DEFAULT NULL COMMENT '商品描述信息',
  `notify_url` varchar(1024) DEFAULT NULL COMMENT '异步通知地址',
  `price` int DEFAULT NULL COMMENT '支付金额，单位：分',
  `channel_fee_rate` double DEFAULT NULL COMMENT '渠道手续费，单位：百分比 冗余 {@link PayChannelDO#getFeeRate()}',
  `channel_fee_price` int DEFAULT NULL COMMENT '渠道手续金额，单位：分',
  `status` int DEFAULT NULL COMMENT '支付状态 枚举 {@link PayOrderStatusEnum}',
  `user_ip` varchar(1024) DEFAULT NULL COMMENT '用户 IP',
  `expire_time` datetime DEFAULT NULL COMMENT '订单失效时间',
  `success_time` datetime DEFAULT NULL COMMENT '订单支付成功时间',
  `extension_id` bigint DEFAULT NULL COMMENT '支付成功的订单拓展单编号 关联 {@link PayOrderExtensionDO#getId()}',
  `no` varchar(1024) DEFAULT NULL COMMENT '支付成功的外部订单号 关联 {@link PayOrderExtensionDO#getNo()}',
  `refund_price` int DEFAULT NULL COMMENT '退款总金额，单位：分',
  `channel_user_id` varchar(1024) DEFAULT NULL COMMENT '渠道用户编号 例如说，微信 openid、支付宝账号',
  `channel_order_no` varchar(1024) DEFAULT NULL COMMENT '渠道订单号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付订单';

DROP TABLE IF EXISTS `pay_order_extension`;
CREATE TABLE `pay_order_extension` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单拓展编号，数据库自增',
  `no` varchar(1024) DEFAULT NULL COMMENT '外部订单号，根据规则生成 调用支付渠道时，使用该字段作为对接的订单号： 1. 微信支付：对应 <a href="https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml">JSAPI 支付</a> 的 out_trade_no 字段 2. 支付宝支付：对应 <a href="https://opendocs.alipay.com/open/270/105898">电脑网站支付</a> 的 out_trade_no 字段 例如说，P202110132239124200055',
  `order_id` bigint DEFAULT NULL COMMENT '订单号 关联 {@link PayOrderDO#getId()}',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道编号 关联 {@link PayChannelDO#getId()}',
  `channel_code` varchar(1024) DEFAULT NULL COMMENT '渠道编码',
  `user_ip` varchar(1024) DEFAULT NULL COMMENT '用户 IP',
  `status` int DEFAULT NULL COMMENT '支付状态 枚举 {@link PayOrderStatusEnum}',
  `channel_extras` longtext DEFAULT NULL COMMENT '支付渠道的额外参数 参见 <a href="https://www.pingxx.com/api/支付渠道%20extra%20参数说明.html">参数说明</>',
  `channel_error_code` varchar(1024) DEFAULT NULL COMMENT '调用渠道的错误码',
  `channel_error_msg` varchar(1024) DEFAULT NULL COMMENT '调用渠道报错时，错误信息',
  `channel_notify_data` varchar(1024) DEFAULT NULL COMMENT '支付渠道的同步/异步通知的内容 对应 {@link PayOrderRespDTO#getRawData()}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付订单拓展 DO 每次调用支付渠道，都会生成一条对应记录';

DROP TABLE IF EXISTS `pay_refund`;
CREATE TABLE `pay_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '退款单编号，数据库自增',
  `no` varchar(1024) DEFAULT NULL COMMENT '外部退款号，根据规则生成 调用支付渠道时，使用该字段作为对接的退款号： 1. 微信退款：对应 <a href="https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_4">申请退款</a> 的 out_refund_no 字段 2. 支付宝退款：对应 <a href="https://opendocs.alipay.com/open/02e7go"统一收单交易退款接口></a> 的 out_request_no 字段',
  `app_id` bigint DEFAULT NULL COMMENT '应用编号 关联 {@link PayAppDO#getId()}',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道编号 关联 {@link PayChannelDO#getId()}',
  `channel_code` varchar(1024) DEFAULT NULL COMMENT '渠道编码 枚举 {@link PayChannelEnum}',
  `order_id` bigint DEFAULT NULL COMMENT '订单编号 关联 {@link PayOrderDO#getId()}',
  `order_no` varchar(1024) DEFAULT NULL COMMENT '支付订单编号 冗余 {@link PayOrderDO#getNo()}',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `user_type` int DEFAULT NULL COMMENT '用户类型',
  `merchant_order_id` varchar(1024) DEFAULT NULL COMMENT '商户订单编号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `merchant_refund_id` varchar(1024) DEFAULT NULL COMMENT '商户退款订单号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `notify_url` varchar(1024) DEFAULT NULL COMMENT '异步通知地址',
  `status` int DEFAULT NULL COMMENT '退款状态 枚举 {@link PayRefundStatusEnum}',
  `pay_price` int DEFAULT NULL COMMENT '支付金额，单位：分',
  `refund_price` int DEFAULT NULL COMMENT '退款金额，单位：分',
  `reason` varchar(1024) DEFAULT NULL COMMENT '退款原因',
  `user_ip` varchar(1024) DEFAULT NULL COMMENT '用户 IP',
  `channel_order_no` varchar(1024) DEFAULT NULL COMMENT '渠道订单号 冗余 {@link PayOrderDO#getChannelOrderNo()}',
  `channel_refund_no` varchar(1024) DEFAULT NULL COMMENT '渠道退款单号 1. 微信退款：对应 <a href="https://pay.weixin.qq.com/wiki/doc/api/micropay.php?chapter=9_4">申请退款</a> 的 refund_id 字段 2. 支付宝退款：没有字段',
  `success_time` datetime DEFAULT NULL COMMENT '退款成功时间',
  `channel_error_code` varchar(1024) DEFAULT NULL COMMENT '调用渠道的错误码',
  `channel_error_msg` varchar(1024) DEFAULT NULL COMMENT '调用渠道的错误提示',
  `channel_notify_data` varchar(1024) DEFAULT NULL COMMENT '支付渠道的同步/异步通知的内容 对应 {@link PayRefundRespDTO#getRawData()}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付退款单 DO 一个支付订单，可以拥有多个支付退款单 即 PayOrderDO : PayRefundDO = 1 : n';

DROP TABLE IF EXISTS `pay_transfer`;
CREATE TABLE `pay_transfer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(1024) DEFAULT NULL COMMENT '转账单号',
  `app_id` bigint DEFAULT NULL COMMENT '应用编号 关联 {@link PayAppDO#getId()}',
  `channel_id` bigint DEFAULT NULL COMMENT '转账渠道编号 关联 {@link PayChannelDO#getId()}',
  `channel_code` varchar(1024) DEFAULT NULL COMMENT '转账渠道编码 枚举 {@link PayChannelEnum}',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `user_type` int DEFAULT NULL COMMENT '用户类型',
  `merchant_transfer_id` varchar(1024) DEFAULT NULL COMMENT '商户转账单编号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `subject` varchar(1024) DEFAULT NULL COMMENT '转账标题',
  `price` int DEFAULT NULL COMMENT '转账金额，单位：分',
  `user_account` varchar(1024) DEFAULT NULL COMMENT '收款人账号',
  `user_name` varchar(1024) DEFAULT NULL COMMENT '收款人姓名',
  `status` int DEFAULT NULL COMMENT '转账状态 枚举 {@link PayTransferStatusEnum}',
  `success_time` datetime DEFAULT NULL COMMENT '订单转账成功时间',
  `notify_url` varchar(1024) DEFAULT NULL COMMENT '异步通知地址',
  `user_ip` varchar(1024) DEFAULT NULL COMMENT '用户 IP',
  `channel_extras` longtext DEFAULT NULL COMMENT '渠道的额外参数',
  `channel_transfer_no` varchar(1024) DEFAULT NULL COMMENT '渠道转账单号',
  `channel_error_code` varchar(1024) DEFAULT NULL COMMENT '调用渠道的错误码',
  `channel_error_msg` varchar(1024) DEFAULT NULL COMMENT '调用渠道的错误提示',
  `channel_notify_data` varchar(1024) DEFAULT NULL COMMENT '渠道的同步/异步通知的内容',
  `channel_package_info` varchar(1024) DEFAULT NULL COMMENT '渠道 package 信息 特殊：目前只有微信转账有这个东西！！！',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='转账单';

DROP TABLE IF EXISTS `pay_wallet`;
CREATE TABLE `pay_wallet` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户 id 关联 MemberUserDO 的 id 编号 关联 AdminUserDO 的 id 编号',
  `user_type` int DEFAULT NULL COMMENT '用户类型, 预留 多商户转帐可能需要用到 关联 {@link UserTypeEnum}',
  `balance` int DEFAULT NULL COMMENT '余额，单位分',
  `freeze_price` int DEFAULT NULL COMMENT '冻结金额，单位分',
  `total_expense` int DEFAULT NULL COMMENT '累计支出，单位分',
  `total_recharge` int DEFAULT NULL COMMENT '累计充值，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包';

DROP TABLE IF EXISTS `pay_wallet_recharge`;
CREATE TABLE `pay_wallet_recharge` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `wallet_id` bigint DEFAULT NULL COMMENT '钱包编号 关联 {@link PayWalletDO#getId()}',
  `total_price` int DEFAULT NULL COMMENT '用户实际到账余额 例如充 100 送 20，则该值是 120',
  `pay_price` int DEFAULT NULL COMMENT '实际支付金额',
  `bonus_price` int DEFAULT NULL COMMENT '钱包赠送金额',
  `package_id` bigint DEFAULT NULL COMMENT '充值套餐编号 关联 {@link PayWalletRechargeDO#getPackageId()} 字段',
  `pay_status` bit(1) DEFAULT NULL COMMENT '是否已支付 true - 已支付 false - 未支付',
  `pay_order_id` bigint DEFAULT NULL COMMENT '支付订单编号 关联 {@link PayOrderDO#getId()}',
  `pay_channel_code` varchar(1024) DEFAULT NULL COMMENT '支付成功的支付渠道 冗余 {@link PayOrderDO#getChannelCode()}',
  `pay_time` datetime DEFAULT NULL COMMENT '订单支付时间',
  `pay_refund_id` bigint DEFAULT NULL COMMENT '支付退款单编号 关联 {@link PayRefundDO#getId()}',
  `refund_total_price` int DEFAULT NULL COMMENT '退款金额，包含赠送金额',
  `refund_pay_price` int DEFAULT NULL COMMENT '退款支付金额',
  `refund_bonus_price` int DEFAULT NULL COMMENT '退款钱包赠送金额',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  `refund_status` int DEFAULT NULL COMMENT '退款状态 枚举 {@link PayRefundStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包充值';

DROP TABLE IF EXISTS `pay_wallet_recharge_package`;
CREATE TABLE `pay_wallet_recharge_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '套餐名',
  `pay_price` int DEFAULT NULL COMMENT '支付金额',
  `bonus_price` int DEFAULT NULL COMMENT '赠送金额',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link cn.iocoder.yudao.framework.common.enums.CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包充值套餐 DO 通过充值套餐时，可以赠送一定金额；';

DROP TABLE IF EXISTS `pay_wallet_transaction`;
CREATE TABLE `pay_wallet_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(1024) DEFAULT NULL COMMENT '流水号',
  `wallet_id` bigint DEFAULT NULL COMMENT '钱包编号 关联 {@link PayWalletDO#getId()}',
  `biz_type` int DEFAULT NULL COMMENT '关联业务分类 枚举 {@link PayWalletBizTypeEnum#getType()}',
  `biz_id` varchar(1024) DEFAULT NULL COMMENT '关联业务编号',
  `title` varchar(1024) DEFAULT NULL COMMENT '流水说明',
  `price` int DEFAULT NULL COMMENT '交易金额，单位分 正值表示余额增加，负值表示余额减少',
  `balance` int DEFAULT NULL COMMENT '交易后余额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包流水';

DROP TABLE IF EXISTS `product_brand`;
CREATE TABLE `product_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '品牌名称',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '品牌图片',
  `sort` int DEFAULT NULL COMMENT '品牌排序',
  `description` longtext DEFAULT NULL COMMENT '品牌描述',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品品牌';

DROP TABLE IF EXISTS `product_browse_history`;
CREATE TABLE `product_browse_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录编号',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `user_deleted` bit(1) DEFAULT NULL COMMENT '用户是否删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品浏览记录';

DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `parent_id` bigint DEFAULT NULL COMMENT '父分类编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '分类名称',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '移动端分类图 建议 180*180 分辨率',
  `sort` int DEFAULT NULL COMMENT '分类排序',
  `status` int DEFAULT NULL COMMENT '开启状态 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类';

DROP TABLE IF EXISTS `product_comment`;
CREATE TABLE `product_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论编号，主键自增',
  `user_id` bigint DEFAULT NULL COMMENT '评价人的用户编号 关联 MemberUserDO 的 id 编号',
  `user_nickname` varchar(1024) DEFAULT NULL COMMENT '评价人名称',
  `user_avatar` varchar(1024) DEFAULT NULL COMMENT '评价人头像',
  `anonymous` bit(1) DEFAULT NULL COMMENT '是否匿名',
  `order_id` bigint DEFAULT NULL COMMENT '交易订单编号 关联 TradeOrderDO 的 id 编号',
  `order_item_id` bigint DEFAULT NULL COMMENT '交易订单项编号 关联 TradeOrderItemDO 的 id 编号',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 {@link ProductSpuDO#getId()}',
  `spu_name` varchar(1024) DEFAULT NULL COMMENT '商品 SPU 名称 关联 {@link ProductSpuDO#getName()}',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号 关联 {@link ProductSkuDO#getId()}',
  `sku_pic_url` varchar(1024) DEFAULT NULL COMMENT '商品 SKU 图片地址 关联 {@link ProductSkuDO#getPicUrl()}',
  `visible` bit(1) DEFAULT NULL COMMENT '是否可见 true:显示 false:隐藏',
  `scores` int DEFAULT NULL COMMENT '评分星级 1-5 分',
  `description_scores` int DEFAULT NULL COMMENT '描述星级 1-5 星',
  `benefit_scores` int DEFAULT NULL COMMENT '服务星级 1-5 星',
  `content` varchar(1024) DEFAULT NULL COMMENT '评论内容',
  `pic_urls` longtext DEFAULT NULL COMMENT '评论图片地址数组',
  `reply_status` bit(1) DEFAULT NULL COMMENT '商家是否回复',
  `reply_user_id` bigint DEFAULT NULL COMMENT '回复管理员编号 关联 AdminUserDO 的 id 编号',
  `reply_content` varchar(1024) DEFAULT NULL COMMENT '商家回复内容',
  `reply_time` datetime DEFAULT NULL COMMENT '商家回复时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品评论';

DROP TABLE IF EXISTS `product_favorite`;
CREATE TABLE `product_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 {@link ProductSpuDO#getId()}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品收藏';

DROP TABLE IF EXISTS `product_property`;
CREATE TABLE `product_property` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(1024) DEFAULT NULL COMMENT '名称',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品属性项';

DROP TABLE IF EXISTS `product_property_value`;
CREATE TABLE `product_property_value` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `property_id` bigint DEFAULT NULL COMMENT '属性项的编号 关联 {@link ProductPropertyDO#getId()}',
  `name` varchar(1024) DEFAULT NULL COMMENT '名称',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品属性值';

DROP TABLE IF EXISTS `product_sku`;
CREATE TABLE `product_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品 SKU 编号，自增',
  `spu_id` bigint DEFAULT NULL COMMENT 'SPU 编号 关联 {@link ProductSpuDO#getId()}',
  `properties` longtext DEFAULT NULL COMMENT '属性数组，JSON 格式',
  `price` int DEFAULT NULL COMMENT '商品价格，单位：分',
  `market_price` int DEFAULT NULL COMMENT '市场价，单位：分',
  `cost_price` int DEFAULT NULL COMMENT '成本价，单位：分',
  `bar_code` varchar(1024) DEFAULT NULL COMMENT '商品条码',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '图片地址',
  `stock` int DEFAULT NULL COMMENT '库存',
  `weight` double DEFAULT NULL COMMENT '商品重量，单位：kg 千克',
  `volume` double DEFAULT NULL COMMENT '商品体积，单位：m^3 平米',
  `first_brokerage_price` int DEFAULT NULL COMMENT '一级分销的佣金，单位：分',
  `second_brokerage_price` int DEFAULT NULL COMMENT '二级分销的佣金，单位：分',
  `sales_count` int DEFAULT NULL COMMENT '商品销量',
  `property_id` bigint DEFAULT NULL COMMENT '属性编号 关联 {@link ProductPropertyDO#getId()}',
  `property_name` varchar(1024) DEFAULT NULL COMMENT '属性名字 冗余 {@link ProductPropertyDO#getName()} 注意：每次属性名字发生变化时，需要更新该冗余',
  `value_id` bigint DEFAULT NULL COMMENT '属性值编号 关联 {@link ProductPropertyValueDO#getId()}',
  `value_name` varchar(1024) DEFAULT NULL COMMENT '属性值名字 冗余 {@link ProductPropertyValueDO#getName()} 注意：每次属性值名字发生变化时，需要更新该冗余',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品 SKU';

DROP TABLE IF EXISTS `product_spu`;
CREATE TABLE `product_spu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品 SPU 编号，自增',
  `name` varchar(1024) DEFAULT NULL COMMENT '商品名称',
  `keyword` varchar(1024) DEFAULT NULL COMMENT '关键字',
  `introduction` varchar(1024) DEFAULT NULL COMMENT '商品简介',
  `description` longtext DEFAULT NULL COMMENT '商品详情',
  `category_id` bigint DEFAULT NULL COMMENT '商品分类编号 关联 {@link ProductCategoryDO#getId()}',
  `brand_id` bigint DEFAULT NULL COMMENT '商品品牌编号 关联 {@link ProductBrandDO#getId()}',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '商品封面图',
  `slider_pic_urls` longtext DEFAULT NULL COMMENT '商品轮播图',
  `sort` int DEFAULT NULL COMMENT '排序字段',
  `status` int DEFAULT NULL COMMENT '商品状态 枚举 {@link ProductSpuStatusEnum}',
  `spec_type` bit(1) DEFAULT NULL COMMENT '规格类型 false - 单规格 true - 多规格',
  `price` int DEFAULT NULL COMMENT '商品价格，单位使用：分 基于其对应的 {@link ProductSkuDO#getPrice()} sku单价最低的商品的',
  `market_price` int DEFAULT NULL COMMENT '市场价，单位使用：分 基于其对应的 {@link ProductSkuDO#getMarketPrice()} sku单价最低的商品的',
  `cost_price` int DEFAULT NULL COMMENT '成本价，单位使用：分 基于其对应的 {@link ProductSkuDO#getCostPrice()} sku单价最低的商品的',
  `stock` int DEFAULT NULL COMMENT '库存 基于其对应的 {@link ProductSkuDO#getStock()} 求和',
  `delivery_types` longtext DEFAULT NULL COMMENT '配送方式数组 对应 DeliveryTypeEnum 枚举',
  `delivery_template_id` bigint DEFAULT NULL COMMENT '物流配置模板编号 对应 TradeDeliveryExpressTemplateDO 的 id 编号',
  `give_integral` int DEFAULT NULL COMMENT '赠送积分',
  `sub_commission_type` bit(1) DEFAULT NULL COMMENT '分销类型 false - 默认 true - 自行设置',
  `sales_count` int DEFAULT NULL COMMENT '商品销量',
  `virtual_sales_count` int DEFAULT NULL COMMENT '虚拟销量',
  `browse_count` int DEFAULT NULL COMMENT '浏览量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品 SPU';

DROP TABLE IF EXISTS `product_statistics`;
CREATE TABLE `product_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `time` date DEFAULT NULL COMMENT '统计日期',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `browse_count` int DEFAULT NULL COMMENT '浏览量',
  `browse_user_count` int DEFAULT NULL COMMENT '访客量',
  `favorite_count` int DEFAULT NULL COMMENT '收藏数量',
  `cart_count` int DEFAULT NULL COMMENT '加购数量',
  `order_count` int DEFAULT NULL COMMENT '下单件数',
  `order_pay_count` int DEFAULT NULL COMMENT '支付件数',
  `order_pay_price` int DEFAULT NULL COMMENT '支付金额，单位：分',
  `after_sale_count` int DEFAULT NULL COMMENT '退款件数',
  `after_sale_refund_price` int DEFAULT NULL COMMENT '退款金额，单位：分',
  `browse_convert_percent` int DEFAULT NULL COMMENT '访客支付转化率（百分比）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品统计';

DROP TABLE IF EXISTS `promotion_article`;
CREATE TABLE `promotion_article` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章管理编号',
  `category_id` bigint DEFAULT NULL COMMENT '分类编号 ArticleCategoryDO#id',
  `spu_id` bigint DEFAULT NULL COMMENT '关联商品编号 ProductSpuDO#id',
  `title` varchar(1024) DEFAULT NULL COMMENT '文章标题',
  `author` varchar(1024) DEFAULT NULL COMMENT '文章作者',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '文章封面图片地址',
  `introduction` varchar(1024) DEFAULT NULL COMMENT '文章简介',
  `browse_count` int DEFAULT NULL COMMENT '浏览次数',
  `sort` int DEFAULT NULL COMMENT '排序',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `recommend_hot` bit(1) DEFAULT NULL COMMENT '是否热门(小程序)',
  `recommend_banner` bit(1) DEFAULT NULL COMMENT '是否轮播图(小程序)',
  `content` varchar(1024) DEFAULT NULL COMMENT '文章内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章管理';

DROP TABLE IF EXISTS `promotion_article_category`;
CREATE TABLE `promotion_article_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章分类编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '文章分类名称',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '图标地址',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章分类';

DROP TABLE IF EXISTS `promotion_banner`;
CREATE TABLE `promotion_banner` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `title` varchar(1024) DEFAULT NULL COMMENT '标题',
  `url` varchar(1024) DEFAULT NULL COMMENT '跳转链接',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '图片链接',
  `sort` int DEFAULT NULL COMMENT '排序',
  `status` int DEFAULT NULL COMMENT '状态 {@link CommonStatusEnum}',
  `position` int DEFAULT NULL COMMENT '定位 {@link BannerPositionEnum}',
  `memo` varchar(1024) DEFAULT NULL COMMENT '备注',
  `browse_count` int DEFAULT NULL COMMENT '点击次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='banner';

DROP TABLE IF EXISTS `promotion_bargain_activity`;
CREATE TABLE `promotion_bargain_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '砍价活动编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '砍价活动名称',
  `start_time` datetime DEFAULT NULL COMMENT '活动开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '活动结束时间',
  `status` int DEFAULT NULL COMMENT '活动状态 枚举 {@link CommonStatusEnum}',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号',
  `bargain_first_price` int DEFAULT NULL COMMENT '砍价起始价格，单位：分',
  `bargain_min_price` int DEFAULT NULL COMMENT '砍价底价，单位：分',
  `stock` int DEFAULT NULL COMMENT '砍价库存(剩余库存砍价时扣减)',
  `total_stock` int DEFAULT NULL COMMENT '砍价总库存',
  `help_max_count` int DEFAULT NULL COMMENT '砍价人数 需要多少人，砍价才能成功，即 {@link BargainRecordDO#getStatus()} 更新为 {@link BargainRecordDO#getStatus()} 成功状态',
  `bargain_count` int DEFAULT NULL COMMENT '帮砍次数 单个活动，用户可以帮砍的次数。 例如说：帮砍次数为 1 时，A 和 B 同时将该活动链接发给 C，C 只能帮其中一个人砍价。',
  `total_limit_count` int DEFAULT NULL COMMENT '总限购数量',
  `random_min_price` int DEFAULT NULL COMMENT '用户每次砍价的最小金额，单位：分',
  `random_max_price` int DEFAULT NULL COMMENT '用户每次砍价的最大金额，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='砍价活动';

DROP TABLE IF EXISTS `promotion_bargain_help`;
CREATE TABLE `promotion_bargain_help` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `activity_id` bigint DEFAULT NULL COMMENT '砍价活动编号 关联 {@link BargainActivityDO#getId()} 字段',
  `record_id` bigint DEFAULT NULL COMMENT '砍价记录编号 关联 {@link BargainRecordDO#getId()} 字段',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `reduce_price` int DEFAULT NULL COMMENT '减少价格，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='砍价助力';

DROP TABLE IF EXISTS `promotion_bargain_record`;
CREATE TABLE `promotion_bargain_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `activity_id` bigint DEFAULT NULL COMMENT '砍价活动编号 关联 {@link BargainActivityDO#getId()} 字段',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号',
  `bargain_first_price` int DEFAULT NULL COMMENT '砍价起始价格，单位：分',
  `bargain_price` int DEFAULT NULL COMMENT '当前砍价，单位：分',
  `status` int DEFAULT NULL COMMENT '砍价状态 砍价成功的条件是：（2 选 1） 1. 砍价到 {@link BargainActivityDO#getBargainMinPrice()} 底价 2. 助力人数到达 {@link BargainActivityDO#getHelpMaxCount()} 人 枚举 {@link BargainRecordStatusEnum}',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `order_id` bigint DEFAULT NULL COMMENT '订单编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='砍价记录 DO TODO';

DROP TABLE IF EXISTS `promotion_combination_activity`;
CREATE TABLE `promotion_combination_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '拼团名称',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id',
  `total_limit_count` int DEFAULT NULL COMMENT '总限购数量',
  `single_limit_count` int DEFAULT NULL COMMENT '单次限购数量',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `user_size` int DEFAULT NULL COMMENT '几人团',
  `virtual_group` bit(1) DEFAULT NULL COMMENT '虚拟成团',
  `status` int DEFAULT NULL COMMENT '活动状态 枚举 {@link CommonStatusEnum}',
  `limit_duration` int DEFAULT NULL COMMENT '限制时长（小时）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拼团活动';

DROP TABLE IF EXISTS `promotion_combination_product`;
CREATE TABLE `promotion_combination_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `activity_id` bigint DEFAULT NULL COMMENT '拼团活动编号',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号',
  `combination_price` int DEFAULT NULL COMMENT '拼团价格，单位分',
  `activity_status` int DEFAULT NULL COMMENT '拼团商品状态 关联 {@link CombinationActivityDO#getStatus()}',
  `activity_start_time` datetime DEFAULT NULL COMMENT '活动开始时间点 冗余 {@link CombinationActivityDO#getStartTime()}',
  `activity_end_time` datetime DEFAULT NULL COMMENT '活动结束时间点 冗余 {@link CombinationActivityDO#getEndTime()}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拼团商品';

DROP TABLE IF EXISTS `promotion_combination_record`;
CREATE TABLE `promotion_combination_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `activity_id` bigint DEFAULT NULL COMMENT '拼团活动编号 关联 {@link CombinationActivityDO#getId()}',
  `combination_price` int DEFAULT NULL COMMENT '拼团商品单价 冗余 {@link CombinationProductDO#getCombinationPrice()}',
  `spu_id` bigint DEFAULT NULL COMMENT 'SPU 编号',
  `spu_name` varchar(1024) DEFAULT NULL COMMENT '商品名字',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '商品图片',
  `sku_id` bigint DEFAULT NULL COMMENT 'SKU 编号',
  `count` int DEFAULT NULL COMMENT '购买的商品数量',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号',
  `nickname` varchar(1024) DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(1024) DEFAULT NULL COMMENT '用户头像',
  `head_id` bigint DEFAULT NULL COMMENT '团长编号 关联 {@link CombinationRecordDO#getId()} 如果是团长，则它的值是 {@link #HEAD_ID_GROUP}',
  `status` int DEFAULT NULL COMMENT '开团状态 关联 {@link CombinationRecordStatusEnum}',
  `order_id` bigint DEFAULT NULL COMMENT '订单编号',
  `user_size` int DEFAULT NULL COMMENT '开团需要人数 关联 {@link CombinationActivityDO#getUserSize()}',
  `user_count` int DEFAULT NULL COMMENT '已加入拼团人数',
  `virtual_group` bit(1) DEFAULT NULL COMMENT '是否虚拟成团 默认为 false。 拼团过期都还没有成功，如果 {@link CombinationActivityDO#getVirtualGroup()} 为 true，则执行虚拟成团的逻辑，才会更新该字段为 true',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间 基于 {@link CombinationRecordDO#getStartTime()} + {@link CombinationActivityDO#getLimitDuration()} 计算',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间 (订单付款后开始的时间)',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间（成团时间/失败时间）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拼团记录 DO 1. 用户参与拼团时，会创建一条记录 2. 团长的拼团记录，和参团人的拼团记录，通过 {@link #headId} 关联';

DROP TABLE IF EXISTS `promotion_coupon`;
CREATE TABLE `promotion_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '优惠劵编号',
  `template_id` bigint DEFAULT NULL COMMENT '优惠劵模板编号 关联 {@link CouponTemplateDO#getId()}',
  `name` varchar(1024) DEFAULT NULL COMMENT '优惠劵名 冗余 {@link CouponTemplateDO#getName()}',
  `status` int DEFAULT NULL COMMENT '优惠码状态 枚举 {@link CouponStatusEnum}',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 字段',
  `take_type` int DEFAULT NULL COMMENT '领取类型 枚举 {@link CouponTakeTypeEnum}',
  `use_price` int DEFAULT NULL COMMENT '是否设置满多少金额可用，单位：分 冗余 {@link CouponTemplateDO#getUsePrice()}',
  `valid_start_time` datetime DEFAULT NULL COMMENT '生效开始时间',
  `valid_end_time` datetime DEFAULT NULL COMMENT '生效结束时间',
  `product_scope` int DEFAULT NULL COMMENT '商品范围 枚举 {@link PromotionProductScopeEnum}',
  `product_scope_values` longtext DEFAULT NULL COMMENT '商品范围编号的数组 冗余 {@link CouponTemplateDO#getProductScopeValues()}',
  `discount_type` int DEFAULT NULL COMMENT '折扣类型 冗余 {@link CouponTemplateDO#getDiscountType()}',
  `discount_percent` int DEFAULT NULL COMMENT '折扣百分比 冗余 {@link CouponTemplateDO#getDiscountPercent()}',
  `discount_price` int DEFAULT NULL COMMENT '优惠金额，单位：分 冗余 {@link CouponTemplateDO#getDiscountPrice()}',
  `discount_limit_price` int DEFAULT NULL COMMENT '折扣上限，仅在 {@link #discountType} 等于 {@link PromotionDiscountTypeEnum#PERCENT} 时生效 冗余 {@link CouponTemplateDO#getDiscountLimitPrice()}',
  `use_order_id` bigint DEFAULT NULL COMMENT '使用订单号',
  `use_time` datetime DEFAULT NULL COMMENT '使用时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠劵';

DROP TABLE IF EXISTS `promotion_coupon_template`;
CREATE TABLE `promotion_coupon_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板编号，自增唯一',
  `name` varchar(1024) DEFAULT NULL COMMENT '优惠劵名',
  `description` longtext DEFAULT NULL COMMENT '优惠券说明',
  `status` int DEFAULT NULL,
  `total_count` int DEFAULT NULL COMMENT '发放数量 -1 - 则表示不限制发放数量',
  `take_limit_count` int DEFAULT NULL COMMENT '每人限领个数 -1 - 则表示不限制',
  `take_type` int DEFAULT NULL COMMENT '领取方式 枚举 {@link CouponTakeTypeEnum}',
  `use_price` int DEFAULT NULL COMMENT '是否设置满多少金额可用，单位：分 0 - 不限制 大于 0 - 多少金额可用',
  `product_scope` int DEFAULT NULL COMMENT '商品范围 枚举 {@link PromotionProductScopeEnum}',
  `product_scope_values` longtext DEFAULT NULL COMMENT '商品范围编号的数组',
  `validity_type` int DEFAULT NULL COMMENT '生效日期类型 枚举 {@link CouponTemplateValidityTypeEnum}',
  `valid_start_time` datetime DEFAULT NULL COMMENT '固定日期 - 生效开始时间 当 {@link #validityType} 为 {@link CouponTemplateValidityTypeEnum#DATE}',
  `valid_end_time` datetime DEFAULT NULL COMMENT '固定日期 - 生效结束时间 当 {@link #validityType} 为 {@link CouponTemplateValidityTypeEnum#DATE}',
  `fixed_start_term` int DEFAULT NULL COMMENT '领取日期 - 开始天数 当 {@link #validityType} 为 {@link CouponTemplateValidityTypeEnum#TERM}',
  `fixed_end_term` int DEFAULT NULL COMMENT '领取日期 - 结束天数 当 {@link #validityType} 为 {@link CouponTemplateValidityTypeEnum#TERM}',
  `discount_type` int DEFAULT NULL COMMENT '折扣类型 枚举 {@link PromotionDiscountTypeEnum}',
  `discount_percent` int DEFAULT NULL COMMENT '折扣百分比 例如，80% 为 80',
  `discount_price` int DEFAULT NULL COMMENT '优惠金额，单位：分 当 {@link #discountType} 为 {@link PromotionDiscountTypeEnum#PRICE} 生效',
  `discount_limit_price` int DEFAULT NULL COMMENT '折扣上限，仅在 {@link #discountType} 等于 {@link PromotionDiscountTypeEnum#PERCENT} 时生效 例如，折扣上限为 20 元，当使用 8 折优惠券，订单金额为 1000 元时，最高只可折扣 20 元，而非 80 元。',
  `take_count` int DEFAULT NULL COMMENT '领取优惠券的数量',
  `use_count` int DEFAULT NULL COMMENT '使用优惠券的次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠劵模板 DO 当用户领取时，会生成 {@link CouponDO} 优惠劵';

DROP TABLE IF EXISTS `promotion_discount_activity`;
CREATE TABLE `promotion_discount_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动编号，主键自增',
  `name` varchar(1024) DEFAULT NULL COMMENT '活动标题',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum} 活动被关闭后，不允许再次开启。',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='限时折扣活动 DO 一个活动下，可以有 {@link DiscountProductDO} 商品； 一个商品，在指定时间段内，只能属于一个活动；';

DROP TABLE IF EXISTS `promotion_discount_product`;
CREATE TABLE `promotion_discount_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `activity_id` bigint DEFAULT NULL COMMENT '限时折扣活动的编号 关联 {@link DiscountActivityDO#getId()}',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的 id 编号',
  `discount_type` int DEFAULT NULL COMMENT '折扣类型 枚举 {@link PromotionDiscountTypeEnum}',
  `discount_percent` int DEFAULT NULL COMMENT '折扣百分比 例如，80% 为 80',
  `discount_price` int DEFAULT NULL COMMENT '优惠金额，单位：分 当 {@link #discountType} 为 {@link PromotionDiscountTypeEnum#PRICE} 生效',
  `activity_name` varchar(1024) DEFAULT NULL COMMENT '活动标题 冗余 {@link DiscountActivityDO#getName()}',
  `activity_status` int DEFAULT NULL COMMENT '活动状态 冗余 {@link DiscountActivityDO#getStatus()}',
  `activity_start_time` datetime DEFAULT NULL COMMENT '活动开始时间点 冗余 {@link DiscountActivityDO#getStartTime()}',
  `activity_end_time` datetime DEFAULT NULL COMMENT '活动结束时间点 冗余 {@link DiscountActivityDO#getEndTime()}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='限时折扣商品';

DROP TABLE IF EXISTS `promotion_diy_page`;
CREATE TABLE `promotion_diy_page` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '装修页面编号',
  `template_id` bigint DEFAULT NULL COMMENT '装修模板编号 关联 {@link DiyTemplateDO#getId()}',
  `name` varchar(1024) DEFAULT NULL COMMENT '页面名称',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `preview_pic_urls` longtext DEFAULT NULL COMMENT '预览图，多个逗号分隔',
  `property` longtext DEFAULT NULL COMMENT '页面属性，JSON 格式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='装修页面';

DROP TABLE IF EXISTS `promotion_diy_template`;
CREATE TABLE `promotion_diy_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '装修模板编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '模板名称',
  `used` bit(1) DEFAULT NULL COMMENT '是否使用',
  `used_time` datetime DEFAULT NULL COMMENT '使用时间',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `preview_pic_urls` longtext DEFAULT NULL COMMENT '预览图',
  `property` longtext DEFAULT NULL COMMENT 'uni-app 底部导航属性，JSON 格式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='装修模板 DO 1. 新建一个模版，下面可以包含多个 {@link DiyPageDO} 页面，例如说首页、我的 2. 如果需要使用某个模版，则将 {@link #used} 设置为 true，表示已使用，有且仅有一个';

DROP TABLE IF EXISTS `promotion_kefu_conversation`;
CREATE TABLE `promotion_kefu_conversation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '会话所属用户 关联 {@link MemberUserRespDTO#getId()}',
  `last_message_time` datetime DEFAULT NULL COMMENT '最后聊天时间',
  `last_message_content` varchar(1024) DEFAULT NULL COMMENT '最后聊天内容',
  `last_message_content_type` int DEFAULT NULL COMMENT '最后发送的消息类型 枚举 {@link KeFuMessageContentTypeEnum}',
  `admin_pinned` bit(1) DEFAULT NULL COMMENT '管理端置顶',
  `user_deleted` bit(1) DEFAULT NULL COMMENT '用户是否可见 false - 可见，默认值 true - 不可见，用户删除时设置为 true',
  `admin_deleted` bit(1) DEFAULT NULL COMMENT '管理员是否可见 false - 可见，默认值 true - 不可见，管理员删除时设置为 true',
  `admin_unread_message_count` int DEFAULT NULL COMMENT '管理员未读消息数 用户发送消息时增加，管理员查看后扣减',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客服会话';

DROP TABLE IF EXISTS `promotion_kefu_message`;
CREATE TABLE `promotion_kefu_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `conversation_id` bigint DEFAULT NULL COMMENT '会话编号 关联 {@link KeFuConversationDO#getId()}',
  `sender_id` bigint DEFAULT NULL COMMENT '发送人编号 存储的是用户编号',
  `sender_type` int DEFAULT NULL COMMENT '发送人类型 枚举，{@link UserTypeEnum}',
  `receiver_id` bigint DEFAULT NULL COMMENT '接收人编号 存储的是用户编号',
  `receiver_type` int DEFAULT NULL COMMENT '接收人类型 枚举，{@link UserTypeEnum}',
  `content_type` int DEFAULT NULL COMMENT '消息类型 枚举 {@link KeFuMessageContentTypeEnum}',
  `content` varchar(1024) DEFAULT NULL COMMENT '消息',
  `read_status` bit(1) DEFAULT NULL COMMENT '是/否已读',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客服消息';

DROP TABLE IF EXISTS `promotion_point_activity`;
CREATE TABLE `promotion_point_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分商城活动编号',
  `spu_id` bigint DEFAULT NULL COMMENT '积分商城活动商品',
  `status` int DEFAULT NULL COMMENT '活动状态 枚举 {@link CommonStatusEnum 对应的类}',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `sort` int DEFAULT NULL COMMENT '排序',
  `stock` int DEFAULT NULL COMMENT '积分商城活动库存(剩余库存积分兑换时扣减)',
  `total_stock` int DEFAULT NULL COMMENT '积分商城活动总库存',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='积分商城活动';

DROP TABLE IF EXISTS `promotion_point_product`;
CREATE TABLE `promotion_point_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分商城商品编号',
  `activity_id` bigint DEFAULT NULL COMMENT '积分商城活动 id 关联 {@link PointActivityDO#getId()}',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号',
  `count` int DEFAULT NULL COMMENT '可兑换次数',
  `point` int DEFAULT NULL COMMENT '所需兑换积分',
  `price` int DEFAULT NULL COMMENT '所需兑换金额，单位：分',
  `stock` int DEFAULT NULL COMMENT '积分商城商品库存',
  `activity_status` int DEFAULT NULL COMMENT '积分商城商品状态 枚举 {@link CommonStatusEnum 对应的类}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='积分商城商品';

DROP TABLE IF EXISTS `promotion_reward_activity`;
CREATE TABLE `promotion_reward_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动编号，主键自增',
  `name` varchar(1024) DEFAULT NULL COMMENT '活动标题',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `condition_type` int DEFAULT NULL COMMENT '条件类型 枚举 {@link PromotionConditionTypeEnum}',
  `product_scope` int DEFAULT NULL COMMENT '商品范围 枚举 {@link PromotionProductScopeEnum}',
  `product_scope_values` longtext DEFAULT NULL COMMENT '商品 SPU 编号的数组',
  `rules` longtext DEFAULT NULL COMMENT '优惠规则的数组',
  `limit` int DEFAULT NULL COMMENT '优惠门槛 1. 满 N 元，单位：分 2. 满 N 件',
  `discount_price` int DEFAULT NULL COMMENT '优惠价格，单位：分',
  `free_delivery` bit(1) DEFAULT NULL COMMENT '是否包邮',
  `point` int DEFAULT NULL COMMENT '赠送的积分',
  `give_coupon_template_counts` longtext DEFAULT NULL COMMENT '赠送的优惠劵 key: 优惠劵模版编号 value：对应的优惠券数量 目的：用于订单支付后赠送优惠券',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='满减送活动';

DROP TABLE IF EXISTS `promotion_seckill_activity`;
CREATE TABLE `promotion_seckill_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀活动编号',
  `spu_id` bigint DEFAULT NULL COMMENT '秒杀活动商品',
  `name` varchar(1024) DEFAULT NULL COMMENT '秒杀活动名称',
  `status` int DEFAULT NULL COMMENT '活动状态 枚举 {@link CommonStatusEnum 对应的类}',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `start_time` datetime DEFAULT NULL COMMENT '活动开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '活动结束时间',
  `sort` int DEFAULT NULL COMMENT '排序',
  `config_ids` longtext DEFAULT NULL COMMENT '秒杀时段 id',
  `total_limit_count` int DEFAULT NULL COMMENT '总限购数量',
  `single_limit_count` int DEFAULT NULL COMMENT '单次限够数量',
  `stock` int DEFAULT NULL COMMENT '秒杀库存(剩余库存秒杀时扣减)',
  `total_stock` int DEFAULT NULL COMMENT '秒杀总库存',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='秒杀活动';

DROP TABLE IF EXISTS `promotion_seckill_config`;
CREATE TABLE `promotion_seckill_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '秒杀时段名称',
  `start_time` varchar(1024) DEFAULT NULL COMMENT '开始时间点',
  `end_time` varchar(1024) DEFAULT NULL COMMENT '结束时间点',
  `slider_pic_urls` longtext DEFAULT NULL COMMENT '秒杀轮播图',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum 对应的类}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='秒杀时段';

DROP TABLE IF EXISTS `promotion_seckill_product`;
CREATE TABLE `promotion_seckill_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀参与商品编号',
  `activity_id` bigint DEFAULT NULL COMMENT '秒杀活动 id 关联 {@link SeckillActivityDO#getId()}',
  `config_ids` longtext DEFAULT NULL COMMENT '秒杀时段 id 关联 {@link SeckillConfigDO#getId()}',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号',
  `seckill_price` int DEFAULT NULL COMMENT '秒杀金额，单位：分',
  `stock` int DEFAULT NULL COMMENT '秒杀库存',
  `activity_status` int DEFAULT NULL COMMENT '秒杀商品状态 枚举 {@link CommonStatusEnum 对应的类}',
  `activity_start_time` datetime DEFAULT NULL COMMENT '活动开始时间点',
  `activity_end_time` datetime DEFAULT NULL COMMENT '活动结束时间点',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='秒杀参与商品';

DROP TABLE IF EXISTS `trade_after_sale`;
CREATE TABLE `trade_after_sale` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后编号，主键自增',
  `no` varchar(1024) DEFAULT NULL COMMENT '售后单号 例如说，1146347329394184195',
  `status` int DEFAULT NULL COMMENT '退款状态 枚举 {@link AfterSaleStatusEnum}',
  `way` int DEFAULT NULL COMMENT '售后方式 枚举 {@link AfterSaleWayEnum}',
  `type` int DEFAULT NULL COMMENT '售后类型 枚举 {@link AfterSaleTypeEnum}',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `apply_reason` varchar(1024) DEFAULT NULL COMMENT '申请原因 type = 退款，对应 trade_after_sale_refund_reason 类型 type = 退货退款，对应 trade_after_sale_refund_and_return_reason 类型',
  `apply_description` varchar(1024) DEFAULT NULL COMMENT '补充描述',
  `apply_pic_urls` longtext DEFAULT NULL COMMENT '补充凭证图片 数组，以逗号分隔',
  `order_id` bigint DEFAULT NULL COMMENT '交易订单编号 关联 {@link TradeOrderDO#getId()}',
  `order_no` varchar(1024) DEFAULT NULL COMMENT '订单流水号 冗余 {@link TradeOrderDO#getNo()}',
  `order_item_id` bigint DEFAULT NULL COMMENT '交易订单项编号 关联 {@link TradeOrderItemDO#getId()}',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id 字段 冗余 {@link TradeOrderItemDO#getSpuId()}',
  `spu_name` varchar(1024) DEFAULT NULL COMMENT '商品 SPU 名称 关联 ProductSkuDO 的 name 字段 冗余 {@link TradeOrderItemDO#getSpuName()}',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的编号',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '商品图片 冗余 {@link TradeOrderItemDO#getPicUrl()}',
  `count` int DEFAULT NULL COMMENT '退货商品数量',
  `audit_time` datetime DEFAULT NULL COMMENT '审批时间',
  `audit_user_id` bigint DEFAULT NULL COMMENT '审批人 关联 AdminUserDO 的 id 编号',
  `audit_reason` varchar(1024) DEFAULT NULL COMMENT '审批备注 注意，只有审批不通过才会填写',
  `refund_price` int DEFAULT NULL COMMENT '退款金额，单位：分。',
  `pay_refund_id` bigint DEFAULT NULL COMMENT '支付退款编号 对接 pay-module-biz 支付服务的退款订单编号，即 PayRefundDO 的 id 编号',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  `logistics_id` bigint DEFAULT NULL COMMENT '退货物流公司编号 关联 LogisticsDO 的 id 编号',
  `logistics_no` varchar(1024) DEFAULT NULL COMMENT '退货物流单号',
  `delivery_time` datetime DEFAULT NULL COMMENT '退货时间',
  `receive_time` datetime DEFAULT NULL COMMENT '收货时间',
  `receive_reason` varchar(1024) DEFAULT NULL COMMENT '收货备注 注意，只有拒绝收货才会填写',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='售后订单，用于处理 {@link TradeOrderDO} 交易订单的退款退货流程';

DROP TABLE IF EXISTS `trade_after_sale_log`;
CREATE TABLE `trade_after_sale_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 1：AdminUserDO 的 id 字段 关联 2：MemberUserDO 的 id 字段',
  `user_type` int DEFAULT NULL COMMENT '用户类型 枚举 {@link UserTypeEnum}',
  `after_sale_id` bigint DEFAULT NULL COMMENT '售后编号 关联 {@link AfterSaleDO#getId()}',
  `before_status` int DEFAULT NULL COMMENT '操作前状态',
  `after_status` int DEFAULT NULL COMMENT '操作后状态',
  `operate_type` int DEFAULT NULL COMMENT '操作类型 枚举 {@link AfterSaleOperateTypeEnum}',
  `content` varchar(1024) DEFAULT NULL COMMENT '操作明细',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易售后日志';

DROP TABLE IF EXISTS `trade_brokerage_record`;
CREATE TABLE `trade_brokerage_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 <p> 关联 MemberUserDO.id',
  `biz_id` varchar(1024) DEFAULT NULL COMMENT '业务编号',
  `biz_type` int DEFAULT NULL COMMENT '业务类型 <p> 枚举 {@link BrokerageRecordBizTypeEnum}',
  `title` varchar(1024) DEFAULT NULL COMMENT '标题',
  `description` longtext DEFAULT NULL COMMENT '说明',
  `price` int DEFAULT NULL COMMENT '金额',
  `total_price` int DEFAULT NULL COMMENT '当前总佣金',
  `status` int DEFAULT NULL COMMENT '状态 <p> 枚举 {@link BrokerageRecordStatusEnum}',
  `frozen_days` int DEFAULT NULL COMMENT '冻结时间（天）',
  `unfreeze_time` datetime DEFAULT NULL COMMENT '解冻时间',
  `source_user_level` int DEFAULT NULL COMMENT '来源用户等级 <p> 被推广用户和 {@link #userId} 的推广层级关系',
  `source_user_id` bigint DEFAULT NULL COMMENT '来源用户编号 <p> 关联 MemberUserDO.id 字段，被推广用户的编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='佣金记录';

DROP TABLE IF EXISTS `trade_brokerage_user`;
CREATE TABLE `trade_brokerage_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户编号 <p> 对应 MemberUserDO 的 id 字段',
  `bind_user_id` bigint DEFAULT NULL COMMENT '推广员编号 <p> 关联 MemberUserDO 的 id 字段',
  `bind_user_time` datetime DEFAULT NULL COMMENT '推广员绑定时间',
  `brokerage_enabled` bit(1) DEFAULT NULL COMMENT '是否有分销资格',
  `brokerage_time` datetime DEFAULT NULL COMMENT '成为分销员时间',
  `brokerage_price` int DEFAULT NULL COMMENT '可用佣金',
  `frozen_price` int DEFAULT NULL COMMENT '冻结佣金',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分销用户';

DROP TABLE IF EXISTS `trade_brokerage_withdraw`;
CREATE TABLE `trade_brokerage_withdraw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 字段',
  `price` int DEFAULT NULL COMMENT '提现金额，单位：分',
  `fee_price` int DEFAULT NULL COMMENT '提现手续费，单位：分',
  `total_price` int DEFAULT NULL COMMENT '当前总佣金，单位：分',
  `type` int DEFAULT NULL COMMENT '提现类型 <p> 枚举 {@link BrokerageWithdrawTypeEnum}',
  `user_name` varchar(1024) DEFAULT NULL COMMENT '提现姓名 1. {@link BrokerageWithdrawTypeEnum#BANK}：银行开户人 2. {@link BrokerageWithdrawTypeEnum#WECHAT_API}：微信真名 3. {@link BrokerageWithdrawTypeEnum#ALIPAY_API}：支付宝真名',
  `user_account` varchar(1024) DEFAULT NULL COMMENT '提现账号 1. {@link BrokerageWithdrawTypeEnum#BANK}：银行账号 2. {@link BrokerageWithdrawTypeEnum#WECHAT_API}：微信 openid 3. {@link BrokerageWithdrawTypeEnum#ALIPAY_API}：支付宝账号',
  `qr_code_url` varchar(1024) DEFAULT NULL COMMENT '收款码',
  `bank_name` varchar(1024) DEFAULT NULL COMMENT '银行名称',
  `bank_address` varchar(1024) DEFAULT NULL COMMENT '开户地址',
  `status` int DEFAULT NULL COMMENT '状态 <p> 枚举 {@link BrokerageWithdrawStatusEnum}',
  `audit_reason` varchar(1024) DEFAULT NULL COMMENT '审核驳回原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `pay_transfer_id` bigint DEFAULT NULL COMMENT '转账单编号 关联 {@link cn.iocoder.yudao.module.pay.api.transfer.dto.PayTransferRespDTO#getId()}',
  `transfer_channel_code` varchar(1024) DEFAULT NULL COMMENT '转账渠道 枚举 {@link cn.iocoder.yudao.module.pay.enums.PayChannelEnum}',
  `transfer_time` datetime DEFAULT NULL COMMENT '转账成功时间',
  `transfer_error_msg` varchar(1024) DEFAULT NULL COMMENT '转账错误提示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='佣金提现';

DROP TABLE IF EXISTS `trade_cart`;
CREATE TABLE `trade_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，唯一自增',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的 id 编号',
  `count` int DEFAULT NULL COMMENT '商品购买数量',
  `selected` bit(1) DEFAULT NULL COMMENT '是否选中',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车的商品信息 DO 每个商品，对应一条记录，通过 {@link #spuId} 和 {@link #skuId} 关联';

DROP TABLE IF EXISTS `trade_config`;
CREATE TABLE `trade_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `after_sale_refund_reasons` longtext DEFAULT NULL COMMENT '售后的退款理由',
  `after_sale_return_reasons` longtext DEFAULT NULL COMMENT '售后的退货理由',
  `delivery_express_free_enabled` bit(1) DEFAULT NULL COMMENT '是否启用全场包邮',
  `delivery_express_free_price` int DEFAULT NULL COMMENT '全场包邮的最小金额，单位：分',
  `delivery_pick_up_enabled` bit(1) DEFAULT NULL COMMENT '是否开启自提',
  `brokerage_enabled` bit(1) DEFAULT NULL COMMENT '是否启用分佣',
  `brokerage_enabled_condition` int DEFAULT NULL COMMENT '分佣模式 <p> 枚举 {@link BrokerageEnabledConditionEnum 对应的类}',
  `brokerage_bind_mode` int DEFAULT NULL COMMENT '分销关系绑定模式 <p> 枚举 {@link BrokerageBindModeEnum 对应的类}',
  `brokerage_poster_urls` longtext DEFAULT NULL COMMENT '分销海报图地址数组',
  `brokerage_first_percent` int DEFAULT NULL COMMENT '一级返佣比例',
  `brokerage_second_percent` int DEFAULT NULL COMMENT '二级返佣比例',
  `brokerage_withdraw_min_price` int DEFAULT NULL COMMENT '用户提现最低金额',
  `brokerage_withdraw_fee_percent` int DEFAULT NULL COMMENT '用户提现手续费百分比',
  `brokerage_frozen_days` int DEFAULT NULL COMMENT '佣金冻结时间(天)',
  `brokerage_withdraw_types` longtext DEFAULT NULL COMMENT '提现方式 <p> 枚举 {@link BrokerageWithdrawTypeEnum 对应的类}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易中心配置';

DROP TABLE IF EXISTS `trade_delivery_express`;
CREATE TABLE `trade_delivery_express` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `code` varchar(1024) DEFAULT NULL COMMENT '快递公司 code',
  `name` varchar(1024) DEFAULT NULL COMMENT '快递公司名称',
  `logo` varchar(1024) DEFAULT NULL COMMENT '快递公司 logo',
  `sort` int DEFAULT NULL COMMENT '排序',
  `status` int DEFAULT NULL COMMENT '状态 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递公司';

DROP TABLE IF EXISTS `trade_delivery_express_template`;
CREATE TABLE `trade_delivery_express_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `name` varchar(1024) DEFAULT NULL COMMENT '模板名称',
  `charge_mode` int DEFAULT NULL COMMENT '配送计费方式 枚举 {@link DeliveryExpressChargeModeEnum}',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递运费模板';

DROP TABLE IF EXISTS `trade_delivery_express_template_charge`;
CREATE TABLE `trade_delivery_express_template_charge` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `template_id` bigint DEFAULT NULL COMMENT '配送模板编号 关联 {@link DeliveryExpressTemplateDO#getId()}',
  `area_ids` longtext DEFAULT NULL COMMENT '配送区域编号列表',
  `charge_mode` int DEFAULT NULL COMMENT '配送计费方式 冗余 {@link DeliveryExpressTemplateDO#getChargeMode()}',
  `start_count` double DEFAULT NULL COMMENT '首件数量(件数,重量，或体积)',
  `start_price` int DEFAULT NULL COMMENT '起步价，单位：分',
  `extra_count` double DEFAULT NULL COMMENT '续件数量(件, 重量，或体积)',
  `extra_price` int DEFAULT NULL COMMENT '额外价，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递运费模板计费配置';

DROP TABLE IF EXISTS `trade_delivery_express_template_free`;
CREATE TABLE `trade_delivery_express_template_free` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `template_id` bigint DEFAULT NULL COMMENT '配送模板编号 关联 {@link DeliveryExpressTemplateDO#getId()}',
  `area_ids` longtext DEFAULT NULL COMMENT '配送区域编号列表',
  `free_price` int DEFAULT NULL COMMENT '包邮金额，单位：分 订单总金额 >= 包邮金额时，才免运费',
  `free_count` int DEFAULT NULL COMMENT '包邮件数 订单总件数 >= 包邮件数时，才免运费',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递运费模板包邮配置';

DROP TABLE IF EXISTS `trade_delivery_pick_up_store`;
CREATE TABLE `trade_delivery_pick_up_store` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(1024) DEFAULT NULL COMMENT '门店名称',
  `introduction` varchar(1024) DEFAULT NULL COMMENT '门店简介',
  `phone` varchar(1024) DEFAULT NULL COMMENT '门店手机',
  `area_id` int DEFAULT NULL COMMENT '区域编号',
  `detail_address` varchar(1024) DEFAULT NULL COMMENT '门店详细地址',
  `logo` varchar(1024) DEFAULT NULL COMMENT '门店 logo',
  `opening_time` time DEFAULT NULL COMMENT '营业开始时间',
  `closing_time` time DEFAULT NULL COMMENT '营业结束时间',
  `latitude` double DEFAULT NULL COMMENT '纬度',
  `longitude` double DEFAULT NULL COMMENT '经度',
  `verify_user_ids` longtext DEFAULT NULL COMMENT '核销员工用户编号数组 订单自提核销时，只有对应门店的店员才能核销 关联 {@link AdminUserRespDTO#getId()} 管理员编号',
  `status` int DEFAULT NULL COMMENT '门店状态 枚举 {@link CommonStatusEnum}',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='自提门店';

DROP TABLE IF EXISTS `trade_order`;
CREATE TABLE `trade_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号，主键自增',
  `no` varchar(1024) DEFAULT NULL COMMENT '订单流水号 例如说，1146347329394184195',
  `type` int DEFAULT NULL COMMENT '订单类型 枚举 {@link TradeOrderTypeEnum}',
  `terminal` int DEFAULT NULL COMMENT '订单来源 枚举 {@link TerminalEnum}',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `user_ip` varchar(1024) DEFAULT NULL COMMENT '用户 IP',
  `user_remark` varchar(1024) DEFAULT NULL COMMENT '用户备注',
  `status` int DEFAULT NULL COMMENT '订单状态 枚举 {@link TradeOrderStatusEnum}',
  `product_count` int DEFAULT NULL COMMENT '购买的商品数量',
  `finish_time` datetime DEFAULT NULL COMMENT '订单完成时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '订单取消时间',
  `cancel_type` int DEFAULT NULL COMMENT '取消类型 枚举 {@link TradeOrderCancelTypeEnum}',
  `remark` varchar(1024) DEFAULT NULL COMMENT '商家备注',
  `comment_status` bit(1) DEFAULT NULL COMMENT '是否评价 true - 已评价 false - 未评价',
  `brokerage_user_id` bigint DEFAULT NULL COMMENT '推广人编号 关联 {@link BrokerageUserDO#getId()} 字段，即 {@link MemberUserRespDTO#getId()} 字段',
  `pay_order_id` bigint DEFAULT NULL COMMENT '支付订单编号 对接 pay-module-biz 支付服务的支付订单编号，即 PayOrderDO 的 id 编号',
  `pay_status` bit(1) DEFAULT NULL COMMENT '是否已支付 true - 已经支付过 false - 没有支付过',
  `pay_time` datetime DEFAULT NULL COMMENT '付款时间',
  `pay_channel_code` varchar(1024) DEFAULT NULL COMMENT '支付渠道 对应 PayChannelEnum 枚举',
  `total_price` int DEFAULT NULL COMMENT '商品原价，单位：分 totalPrice = {@link TradeOrderItemDO#getPrice()} * {@link TradeOrderItemDO#getCount()} 求和 对应 taobao 的 trade.total_fee 字段',
  `discount_price` int DEFAULT NULL COMMENT '优惠金额，单位：分 对应 taobao 的 order.discount_fee 字段',
  `delivery_price` int DEFAULT NULL COMMENT '运费金额，单位：分',
  `adjust_price` int DEFAULT NULL COMMENT '订单调价，单位：分 正数，加价；负数，减价',
  `pay_price` int DEFAULT NULL COMMENT '应付金额（总），单位：分 = {@link #totalPrice} - {@link #couponPrice} - {@link #pointPrice} - {@link #discountPrice} + {@link #deliveryPrice} + {@link #adjustPrice} - {@link #vipPrice}',
  `delivery_type` int DEFAULT NULL COMMENT '配送方式 枚举 {@link DeliveryTypeEnum}',
  `logistics_id` bigint DEFAULT NULL COMMENT '发货物流公司编号 如果无需发货，则 logisticsId 设置为 0。原因是，不想再添加额外字段 关联 {@link DeliveryExpressDO#getId()}',
  `logistics_no` varchar(1024) DEFAULT NULL COMMENT '发货物流单号 如果无需发货，则 logisticsNo 设置 ""。原因是，不想再添加额外字段',
  `delivery_time` datetime DEFAULT NULL COMMENT '发货时间',
  `receive_time` datetime DEFAULT NULL COMMENT '收货时间',
  `receiver_name` varchar(1024) DEFAULT NULL COMMENT '收件人名称',
  `receiver_mobile` varchar(1024) DEFAULT NULL COMMENT '收件人手机',
  `receiver_area_id` int DEFAULT NULL COMMENT '收件人地区编号',
  `receiver_detail_address` varchar(1024) DEFAULT NULL COMMENT '收件人详细地址',
  `pick_up_store_id` bigint DEFAULT NULL COMMENT '自提门店编号 关联 {@link DeliveryPickUpStoreDO#getId()}',
  `pick_up_verify_code` varchar(1024) DEFAULT NULL COMMENT '自提核销码',
  `refund_status` int DEFAULT NULL COMMENT '售后状态 枚举 {@link TradeOrderRefundStatusEnum}',
  `refund_price` int DEFAULT NULL COMMENT '退款金额，单位：分 注意，退款并不会影响 {@link #payPrice} 实际支付金额 也就说，一个订单最终产生多少金额的收入 = payPrice - refundPrice',
  `coupon_id` bigint DEFAULT NULL COMMENT '优惠劵编号',
  `coupon_price` int DEFAULT NULL COMMENT '优惠劵减免金额，单位：分 对应 taobao 的 trade.coupon_fee 字段',
  `use_point` int DEFAULT NULL COMMENT '使用的积分',
  `point_price` int DEFAULT NULL COMMENT '积分抵扣的金额，单位：分 对应 taobao 的 trade.point_fee 字段',
  `give_point` int DEFAULT NULL COMMENT '赠送的积分',
  `refund_point` int DEFAULT NULL COMMENT '退还的使用的积分',
  `vip_price` int DEFAULT NULL COMMENT 'VIP 减免金额，单位：分',
  `give_coupon_template_counts` longtext DEFAULT NULL COMMENT '赠送的优惠劵 key: 优惠劵模版编号 value：对应的优惠券数量 目的：用于订单支付后赠送优惠券',
  `give_coupon_ids` longtext DEFAULT NULL COMMENT '赠送的优惠劵编号 目的：用于后续取消或者售后订单时，需要扣减赠送',
  `seckill_activity_id` bigint DEFAULT NULL COMMENT '秒杀活动编号 关联 SeckillActivityDO 的 id 字段',
  `bargain_activity_id` bigint DEFAULT NULL COMMENT '砍价活动编号 关联 BargainActivityDO 的 id 字段',
  `bargain_record_id` bigint DEFAULT NULL COMMENT '砍价记录编号 关联 BargainRecordDO 的 id 字段',
  `combination_activity_id` bigint DEFAULT NULL COMMENT '拼团活动编号 关联 CombinationActivityDO 的 id 字段',
  `combination_head_id` bigint DEFAULT NULL COMMENT '拼团团长编号 关联 CombinationRecordDO 的 headId 字段',
  `combination_record_id` bigint DEFAULT NULL COMMENT '拼团记录编号 关联 CombinationRecordDO 的 id 字段',
  `point_activity_id` bigint DEFAULT NULL COMMENT '积分商城活动的编号 关联 PointActivityDO 的 id 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易订单';

DROP TABLE IF EXISTS `trade_order_item`;
CREATE TABLE `trade_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `order_id` bigint DEFAULT NULL COMMENT '订单编号 关联 {@link TradeOrderDO#getId()}',
  `cart_id` bigint DEFAULT NULL COMMENT '购物车项编号 关联 {@link CartDO#getId()}',
  `spu_id` bigint DEFAULT NULL COMMENT '商品 SPU 编号 关联 ProductSkuDO 的 spuId 编号',
  `spu_name` varchar(1024) DEFAULT NULL COMMENT '商品 SPU 名称 冗余 ProductSkuDO 的 spuName 编号',
  `sku_id` bigint DEFAULT NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的 id 编号',
  `properties` longtext DEFAULT NULL COMMENT '属性数组，JSON 格式 冗余 ProductSkuDO 的 properties 字段',
  `pic_url` varchar(1024) DEFAULT NULL COMMENT '商品图片',
  `count` int DEFAULT NULL COMMENT '购买数量',
  `comment_status` bit(1) DEFAULT NULL COMMENT '是否评价 true - 已评价 false - 未评价',
  `price` int DEFAULT NULL COMMENT '商品原价（单），单位：分 对应 ProductSkuDO 的 price 字段 对应 taobao 的 order.price 字段',
  `discount_price` int DEFAULT NULL COMMENT '优惠金额（总），单位：分 对应 taobao 的 order.discount_fee 字段',
  `delivery_price` int DEFAULT NULL COMMENT '运费金额（总），单位：分',
  `adjust_price` int DEFAULT NULL COMMENT '订单调价（总），单位：分 正数，加价；负数，减价',
  `pay_price` int DEFAULT NULL COMMENT '应付金额（总），单位：分 = {@link #price} * {@link #count} - {@link #couponPrice} - {@link #pointPrice} - {@link #discountPrice} + {@link #deliveryPrice} + {@link #adjustPrice} - {@link #vipPrice}',
  `coupon_price` int DEFAULT NULL COMMENT '优惠劵减免金额，单位：分 对应 taobao 的 trade.coupon_fee 字段',
  `point_price` int DEFAULT NULL COMMENT '积分抵扣的金额，单位：分 对应 taobao 的 trade.point_fee 字段',
  `use_point` int DEFAULT NULL COMMENT '使用的积分 目的：用于后续取消或者售后订单时，需要归还赠送',
  `give_point` int DEFAULT NULL COMMENT '赠送的积分 目的：用于后续取消或者售后订单时，需要扣减赠送',
  `vip_price` int DEFAULT NULL COMMENT 'VIP 减免金额，单位：分',
  `after_sale_id` bigint DEFAULT NULL COMMENT '售后单编号 关联 {@link AfterSaleDO#getId()} 字段',
  `after_sale_status` int DEFAULT NULL COMMENT '售后状态 枚举 {@link TradeOrderItemAfterSaleStatusEnum}',
  `property_id` bigint DEFAULT NULL COMMENT '属性编号 关联 ProductPropertyDO 的 id 编号',
  `property_name` varchar(1024) DEFAULT NULL COMMENT '属性名字 关联 ProductPropertyDO 的 name 字段',
  `value_id` bigint DEFAULT NULL COMMENT '属性值编号 关联 ProductPropertyValueDO 的 id 编号',
  `value_name` varchar(1024) DEFAULT NULL COMMENT '属性值名字 关联 ProductPropertyValueDO 的 name 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易订单项';

DROP TABLE IF EXISTS `trade_order_log`;
CREATE TABLE `trade_order_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户编号 关联 AdminUserDO 的 id 字段、或者 MemberUserDO 的 id 字段',
  `user_type` int DEFAULT NULL COMMENT '用户类型 枚举 {@link UserTypeEnum}',
  `order_id` bigint DEFAULT NULL COMMENT '订单号 关联 {@link TradeOrderDO#getId()}',
  `before_status` int DEFAULT NULL COMMENT '操作前状态',
  `after_status` int DEFAULT NULL COMMENT '操作后状态',
  `operate_type` int DEFAULT NULL COMMENT '操作类型 {@link TradeOrderOperateTypeEnum}',
  `content` varchar(1024) DEFAULT NULL COMMENT '订单日志信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单日志';

DROP TABLE IF EXISTS `trade_statistics`;
CREATE TABLE `trade_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `time` datetime DEFAULT NULL COMMENT '统计日期',
  `order_create_count` int DEFAULT NULL COMMENT '创建订单数',
  `order_pay_count` int DEFAULT NULL COMMENT '支付订单商品数',
  `order_pay_price` int DEFAULT NULL COMMENT '总支付金额，单位：分',
  `after_sale_count` int DEFAULT NULL COMMENT '退款订单数',
  `after_sale_refund_price` int DEFAULT NULL COMMENT '总退款金额，单位：分',
  `brokerage_settlement_price` int DEFAULT NULL COMMENT '佣金金额（已结算），单位：分',
  `wallet_pay_price` int DEFAULT NULL COMMENT '总支付金额（余额），单位：分',
  `recharge_pay_count` int DEFAULT NULL COMMENT '充值订单数 <p> 从 PayWalletRechargeDO 计算',
  `recharge_pay_price` int DEFAULT NULL COMMENT '充值金额，单位：分',
  `recharge_refund_count` int DEFAULT NULL COMMENT '充值退款订单数',
  `recharge_refund_price` int DEFAULT NULL COMMENT '充值退款金额，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易统计 DO <p> 以天为维度，统计全部的数据';

SET FOREIGN_KEY_CHECKS = 1;
