# DEV_FLUTTER.md

# Project

Name

Cibei Space Mobile

Package

com.xxh.cibei

Platforms

- Android
- iOS

Framework

Flutter Stable

Language

Dart 3

---

# Vision

Cibei Space Mobile 是 Cibei Space 的官方移动客户端。

定位：

现代化佛学学习 App。

不是独立后台。

所有业务数据均来自 Web API。

移动端专注：

- 阅读体验
- 收藏
- 笔记
- AI 问答
- 离线缓存
- 推送通知

Web 与 Mobile 共用数据库。

禁止移动端维护独立数据结构。

---

# Backend

所有数据来自：

https://cibei.space/api

移动端不得直接连接 PostgreSQL。

不得直接连接 Drizzle。

不得实现后台逻辑。

所有数据必须通过 REST API 获取。

未来支持：

GraphQL

---

# Architecture

必须采用

Clean Architecture

目录结构：

lib/

    core/

        api/

        network/

        storage/

        constants/

        theme/

        router/

        utils/

        widgets/

        services/

    features/

        home/

        sutra/

        dictionary/

        encyclopedia/

        stories/

        notes/

        ai/

        profile/

        settings/

    shared/

        models/

        components/

        extensions/

    app.dart

---

# State Management

Riverpod

禁止：

Provider

GetX

MVC

Bloc

统一使用：

flutter_riverpod

---

# Network

使用：

Dio

要求：

统一封装 ApiClient

支持：

GET

POST

PUT

DELETE

自动：

Authorization

Retry

Refresh Token

Timeout

Error Handle

Logging

---

# Local Storage

Hive

缓存：

首页

经典

词典

故事

阅读历史

最近搜索

用户设置

收藏

支持：

离线阅读

---

# Authentication

Better Auth API

登录方式：

Email

Google

Apple

未来：

微信登录

游客模式

Token

Access Token

Refresh Token

自动刷新

---

# Theme

设计风格：

Apple Design Award

关键词：

Quiet

Elegant

Reading First

Minimal

大量留白

大字号

柔和动画

禁止：

渐变背景

复杂阴影

炫酷动画

宗教金色装饰过多

---

# Color

Primary

#C9A24A

Background

White

Dark Background

#111111

Text

Black

Secondary Text

Gray

Divider

#EEEEEE

---

# Typography

字体：

iOS

SF Pro

Android

Noto Sans SC

标题：

24~34

正文：

18

行高：

1.8

阅读页面：

支持字号调整

支持行距调整

支持宽度调整

支持夜间模式

---

# Navigation

GoRouter

底部导航：

Home

Library

Stories

AI

Profile

不得超过五个 Tab

---

# Core Pages

## Home

内容：

今日经典

佛经故事

学习路线

AI 推荐

热门词条

最近更新

---

## Sutra

浏览经典

搜索

分类

详情

阅读

收藏

分享

下载海报

---

## Dictionary

词典浏览

搜索

详情

相关词

---

## Encyclopedia

人物

宗派

经典

历史

详情

---

## Stories

故事列表

分类

详情

关联经典

相关推荐

---

## AI

聊天

历史记录

引用经典

生成学习计划

免责声明：

AI 内容仅供学习参考。

---

## Notes

我的笔记

高亮

摘录

同步

---

## Profile

登录

设置

阅读统计

学习记录

收藏

笔记

---

# Offline Reading

支持：

缓存经典

缓存故事

缓存词典

最近阅读

自动更新缓存

缓存策略：

LRU

最大缓存：

500MB

---

# Search

搜索来源：

Web API

支持：

经典

词典

百科

故事

搜索建议

搜索历史

热门搜索

---

# Notifications

Firebase Cloud Messaging

通知：

每日经典

学习提醒

更新提醒

收藏更新

AI 回复

---

# Share

支持：

系统分享

复制链接

下载分享海报

分享图片

---

# API Rules

所有 API：

REST

示例：

GET

/api/home

/api/sutras

/api/sutras/{slug}

GET

/api/stories

/api/stories/{slug}

GET

/api/dictionary

GET

/api/encyclopedia

POST

/api/ai/chat

POST

/api/auth/login

POST

/api/auth/logout

禁止：

硬编码 URL

统一：

ApiEndpoints

---

# Models

所有 Model：

Freezed

JSON Serializable

禁止手写：

fromJson

toJson

---

# Image

CachedNetworkImage

支持：

缓存

占位图

错误图

渐进加载

---

# Markdown

flutter_markdown

支持：

标题

引用

表格

代码块

脚注

---

# Accessibility

支持：

Dynamic Type

VoiceOver

TalkBack

高对比度

深色模式

横屏

---

# Performance

首页：

首次打开

<2 秒

滚动：

60 FPS

图片：

懒加载

分页：

Infinite Scroll

列表：

Sliver

---

# Analytics

Firebase Analytics

事件：

打开经典

阅读时长

搜索

AI

收藏

分享

登录

---

# Testing

必须：

Widget Test

Repository Test

API Test

Golden Test

CI 自动运行

---

# CI/CD

GitHub Actions

自动：

Analyze

Test

Build Android

Build iOS

---

# Packages

flutter_riverpod

dio

go_router

freezed

json_serializable

cached_network_image

flutter_markdown

flutter_secure_storage

hive

hive_flutter

firebase_core

firebase_messaging

firebase_analytics

intl

url_launcher

share_plus

connectivity_plus

package_info_plus

device_info_plus

---

# Coding Style

必须：

Feature First

Single Responsibility

禁止超过：

300 行 Widget

禁止：

God Widget

所有页面：

Stateless 优先

业务逻辑：

Controller

Repository

Service

分离

---

# Naming

页面：

SutraPage

StoryDetailPage

组件：

StoryCard

ReadingToolbar

AiMessage

Repository：

StoryRepository

API：

StoryApi

Model：

StoryModel

Entity：

Story

---

# Future

规划：

iPad

MacOS

Windows

Linux

Web Flutter

Wear OS

Apple Watch

---

# Product Goal

打造中文体验最好的佛学学习 App。

阅读体验优于 Kindle。

设计风格接近 Apple Books。

内容深度达到 CBETA 学习入口。

AI 成为个人佛学学习助手，而非宗教咨询工具。

---

# Claude Code Rules

Claude Code 在开发过程中必须遵循以下原则：

1. 严格遵守 Clean Architecture。
2. 优先复用共享组件，不重复造轮子。
3. 不修改 API 协议，如需新增接口，应先提出建议。
4. 所有网络请求统一通过 ApiClient。
5. 所有页面必须适配 Android 与 iOS。
6. 优先实现 MVP，再逐步增加高级功能。
7. 保持代码风格一致，确保可测试、可维护。
8. 每次新增功能时，同时生成对应的 Model、Repository、Controller、Page 与 Widget。
9. 所有字符串支持国际化（`intl`），默认提供中文和英文。
10. 所有新增页面都应考虑深色模式、离线缓存和无障碍支持。