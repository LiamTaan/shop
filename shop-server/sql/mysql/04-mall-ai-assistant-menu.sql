-- Expose the mall AI assistant without restoring the unrelated generic AI menu suite.
-- Safe to execute repeatedly against an existing MySQL database.

SET NAMES utf8mb4;

UPDATE `system_menu`
SET `name` = '商城 AI 助手',
    `permission` = '',
    `type` = 2,
    `sort` = 90,
    `parent_id` = 2362,
    `path` = 'ai-assistant',
    `icon` = 'ep:magic-stick',
    `component` = 'ai/chat/index/index.vue',
    `component_name` = 'AiChat',
    `status` = 0,
    `visible` = b'1',
    `keep_alive` = b'1',
    `always_show` = b'1',
    `updater` = 'local-bootstrap',
    `deleted` = b'0'
WHERE `id` = 2759;

UPDATE `system_role_menu`
SET `deleted` = b'0',
    `updater` = 'local-bootstrap'
WHERE `role_id` = 2
  AND `menu_id` = 2759
  AND `tenant_id` = 1;

INSERT INTO `system_role_menu`
  (`role_id`, `menu_id`, `creator`, `updater`, `deleted`, `tenant_id`)
SELECT 2, 2759, 'local-bootstrap', 'local-bootstrap', b'0', 1
WHERE NOT EXISTS (
  SELECT 1
  FROM `system_role_menu`
  WHERE `role_id` = 2
    AND `menu_id` = 2759
    AND `tenant_id` = 1
);
