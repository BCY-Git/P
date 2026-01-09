/*
 Navicat Premium Data Transfer

 Source Server         : Martin
 Source Server Type    : MySQL
 Source Server Version : 90500 (9.5.0)
 Source Host           : localhost:3306
 Source Schema         : cms

 Target Server Type    : MySQL
 Target Server Version : 90500 (9.5.0)
 File Encoding         : 65001

 Date: 09/01/2026 18:46:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `taskName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `taskPurpose` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '任务目的',
  `taskFrom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '任务来源（如下级）',
  `isCreateByTemplate` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否通过模板创建 0-否 1-是',
  `isTemplateData` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否为模板数据 0-否 1-是',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '类型，逗号分隔的数字',
  `equipment` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '装备，逗号分隔的数字',
  `startTime` datetime NOT NULL COMMENT '任务开始时间',
  `endTime` datetime NOT NULL COMMENT '任务结束时间',
  `remasks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  `publishStatus` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '发布状态 0-未发布 1-已发布',
  `surroundingsId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '-1' COMMENT '环境ID',
  `createUser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人ID',
  `createTime` datetime NOT NULL COMMENT '创建时间',
  `updateUser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '更新人ID',
  `updateTime` datetime NOT NULL COMMENT '更新时间',
  `terrain` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地形',
  `weather` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '天气编码',
  `seaState` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '海况编码',
  `area` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域',
  `drillId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '演练ID',
  `dirllStatus` int NULL DEFAULT 0 COMMENT '演练状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES (1, '任务打', '演练', '下级', '0', '0', '', '', '2025-01-03 14:10:00', '2025-01-03 14:30:00', '无', NULL, '-1', '1', '2025-03-04 11:20:00', '1', '2025-03-06 12:40:31', NULL, '3', '2', NULL, NULL, NULL);
INSERT INTO `task` VALUES (2, '实战训练任务', '提升实战能力', '上级', '1', '0', '1,3,5', '1,5,7', '2025-01-05 09:00:00', '2025-01-05 11:30:00', '注意安全防护', '1', '2', '2', '2025-03-05 08:15:00', '2', '2025-03-05 09:20:15', '山地', '1', '1', '华东区域', 'DR20250105', 1);
INSERT INTO `task` VALUES (3, '设备调试任务', '检测新装备性能', '本级', '0', '1', '3,6', '2,8,9', '2025-01-08 13:00:00', '2025-01-08 16:00:00', '记录设备参数', '0', '3', '1', '2025-03-06 10:30:00', '3', '2025-03-07 15:10:22', NULL, '2', '3', NULL, NULL, 0);
INSERT INTO `task` VALUES (4, '跨区域联合演练', '协同作战能力验证', '上级', '1', '0', '2,4,7', '1,3,6,8', '2025-01-10 08:00:00', '2025-01-10 18:00:00', '多部门配合', '1', '4', '4', '2025-03-08 09:40:00', '4', '2025-03-08 10:15:45', '平原', '4', '2', '华北区域', 'DR20250110', 2);
INSERT INTO `task` VALUES (5, '应急响应演练', '突发情况处置', '下级', '0', '0', '1,5', '4,7,10', '2025-01-12 10:00:00', '2025-01-12 12:00:00', '快速响应', '0', '-1', '3', '2025-03-09 11:25:00', '1', '2025-03-09 14:30:50', '沿海', '5', '4', '华南沿海', NULL, 1);
INSERT INTO `task` VALUES (6, '打算', '的', '', '0', '0', '', '', '2026-01-04 05:55:12', '2026-01-04 13:55:12', '3额', '0', '-1', 'admin', '2026-01-04 13:56:46', 'admin', '2026-01-04 13:56:46', NULL, '', '', NULL, NULL, 0);
INSERT INTO `task` VALUES (7, '对对对', '滴滴滴', '', '0', '0', '', '', '2026-01-04 13:56:50', '2026-01-04 13:56:50', 'null', '0', '-1', 'admin', '2026-01-04 13:56:58', 'admin', '2026-01-04 13:56:58', NULL, '', '', NULL, NULL, 0);
INSERT INTO `task` VALUES (8, '大撒大声地', '达大厦', '', '0', '0', '', '', '2026-01-04 13:57:04', '2026-01-08 05:57:04', '3而且', '0', '-1', 'admin', '2026-01-04 13:57:18', 'admin', '2026-01-04 13:57:18', NULL, '', '', NULL, NULL, 0);
INSERT INTO `task` VALUES (9, '阿达', '大大', '', '0', '0', '', '', '2026-01-04 13:58:07', '2026-01-14 05:58:07', '阿打算', '0', '-1', 'admin', '2026-01-04 13:58:20', 'admin', '2026-01-04 13:58:20', NULL, '', '', NULL, NULL, 0);
INSERT INTO `task` VALUES (10, '大声道', '大大', '', '0', '0', '3', '3', '2026-01-04 14:05:46', '2026-01-04 14:05:46', '大声道', '0', '-1', 'admin', '2026-01-04 14:05:57', 'admin', '2026-01-04 14:05:57', NULL, '', '', NULL, NULL, 0);
INSERT INTO `task` VALUES (11, '1', '2', '', '0', '0', '', '', '2026-01-09 10:50:14', '2026-01-09 10:50:14', 'null', '0', '-1', 'admin', '2026-01-09 10:50:27', 'admin', '2026-01-09 10:50:27', NULL, '', '', NULL, NULL, 0);

SET FOREIGN_KEY_CHECKS = 1;
