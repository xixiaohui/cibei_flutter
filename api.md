# Cibei Space — API Documentation

> 供 `cibei_flutter` 移动端项目对接使用
>
> 状态说明：
> - ✅ **已实现** — REST 端点已存在，Flutter 可直接调用
> - 🔨 **待新增** — 当前为 Next.js 服务端函数（直连 DB），需先暴露为 REST 端点后才能调用

---

## 1. 基础信息

| 项目 | 值 |
|------|-----|
| Base URL | `https://cibei.space` |
| 认证方式 | Better Auth — Cookie/Session 机制 |
| 内容类型 | `application/json`（海报 API 除外） |
| 字符编码 | UTF-8 |

### 1.1 认证说明

当前认证使用 Better Auth，采用 **Cookie + Session** 机制。Flutter 客户端需要：

- **登录/注册**：POST `/api/auth/sign-in/email` / `/api/auth/sign-up/email`
- **Session 管理**：接收并存储 `Set-Cookie` 响应头，后续请求自动携带 Cookie
- **登出**：POST `/api/auth/sign-out`

标记为"需要登录"的接口，请求必须携带有效 Session Cookie。

### 1.2 通用约定

**分页请求参数：**

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `page` | integer | 1 | 页码 |
| `pageSize` | integer | 20 | 每页条数（可选 20/50/100） |

**分页响应格式：**

```json
{
  "items": [],
  "total": 140,
  "page": 1,
  "pageSize": 20,
  "totalPages": 7
}
```

**错误响应格式：**

```json
{
  "error": "错误描述信息"
}
```

---

## 2. 认证 API — ✅ 已实现

基于 Better Auth，端点统一挂载在 `/api/auth/[...all]`。

### 2.1 邮箱注册

```
POST /api/auth/sign-up/email
```

**请求体：**

```json
{
  "email": "user@example.com",
  "password": "your-password",
  "name": "用户名"
}
```

**响应（200）：**

```json
{
  "token": "...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "用户名",
    "image": null,
    "emailVerified": false,
    "createdAt": "2026-06-24T00:00:00.000Z",
    "updatedAt": null
  }
}
```

### 2.2 邮箱登录

```
POST /api/auth/sign-in/email
```

**请求体：**

```json
{
  "email": "user@example.com",
  "password": "your-password"
}
```

**响应（200）：** 同注册响应格式

### 2.3 获取当前 Session

```
GET /api/auth/get-session
```

**响应（200，已登录）：**

```json
{
  "session": {
    "id": "session-id",
    "userId": "user-id",
    "token": "session-token",
    "expiresAt": "2026-07-24T00:00:00.000Z",
    "ipAddress": "...",
    "userAgent": "..."
  },
  "user": {
    "id": "user-id",
    "email": "user@example.com",
    "name": "用户名",
    "image": null,
    "emailVerified": false,
    "createdAt": "2026-06-24T00:00:00.000Z",
    "updatedAt": null
  }
}
```

**响应（200，未登录）：**

```json
{
  "session": null,
  "user": null
}
```

### 2.4 登出

```
POST /api/auth/sign-out
```

**响应（200）：**

```json
{
  "success": true
}
```

---

## 3. 搜索 API — ✅ 已实现

### 3.1 全局搜索

```
GET /api/search?q={keyword}&type={filter}
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `q` | string | 是 | 搜索关键词 |
| `type` | string | 否 | 筛选类型：`sutras` / `glossary` / `encyclopedia`。不传则搜索全部 |

**响应（200）：**

```json
{
  "results": [
    {
      "type": "sutra",
      "slug": "diamond-sutra",
      "title": "金刚般若波罗蜜经",
      "excerpt": "如是我闻。一时，佛在舍卫国祇树给孤独园...",
      "category": "般若部"
    },
    {
      "type": "glossary",
      "slug": "prajna",
      "title": "般若",
      "excerpt": "梵语 prajñā 的音译，意为智慧...",
      "category": null
    },
    {
      "type": "encyclopedia",
      "slug": "nagarjuna",
      "title": "龙树",
      "excerpt": "龙树（Nāgārjuna），大乘佛教中观学派创始人...",
      "category": "人物"
    }
  ],
  "total": 3
}
```

**说明：**
- 每个类型最多返回 10 条结果
- 搜索范围：`sutras`（标题 + 摘要）、`glossary`（术语 + 释义）、`encyclopedia`（标题 + 正文）

---

## 4. 海报 API — ✅ 已实现

### 4.1 生成分享海报

```
GET /api/poster/{type}/{slug}
```

**路径参数：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `type` | string | `sutra` / `dictionary` / `encyclopedia` / `story` |
| `slug` | string | 对应内容的 slug |

**响应（200）：** PNG 图片（800×1280），24 小时缓存

**响应头：**
```
Content-Type: image/png
Cache-Control: public, max-age=86400, immutable
```

**错误响应：**
- `400` — 无效的 type 参数
- `404` — 未找到对应内容

---

## 5. 经典库 API — ✅ 已实现

> 端点位置：`src/app/api/sutras/`

### 5.1 经典列表

```
GET /api/sutras
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `category` | string | 否 | 分类筛选（如 "般若部"） |
| `hasExternal` | boolean | 否 | 仅显示有外部链接（CBETA/SAT）的经典 |
| `page` | integer | 否 | 页码，默认 1 |
| `pageSize` | integer | 否 | 每页条数，默认 20 |

**响应（200）：**

```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "diamond-sutra",
      "title": "金刚般若波罗蜜经",
      "titleEn": "Diamond Sutra",
      "dynasty": "唐",
      "translator": "鸠摩罗什",
      "summary": "《金刚经》是大乘佛教般若部重要经典...",
      "category": "般若部",
      "cbetaId": "T0235",
      "satId": null,
      "createdAt": "2026-06-24T00:00:00.000Z"
    }
  ],
  "total": 8,
  "page": 1,
  "pageSize": 20,
  "totalPages": 1
}
```

### 5.2 经典详情

```
GET /api/sutras/{slug}
```

**响应（200）：**

```json
{
  "id": "uuid",
  "slug": "diamond-sutra",
  "title": "金刚般若波罗蜜经",
  "titleEn": "Diamond Sutra",
  "dynasty": "唐",
  "translator": "鸠摩罗什",
  "summary": "《金刚经》是大乘佛教般若部重要经典...",
  "category": "般若部",
  "cbetaId": "T0235",
  "satId": null,
  "createdAt": "2026-06-24T00:00:00.000Z"
}
```

> **注意：** 经典详情接口只返回元数据。正文通过 `/api/sutras/{slug}/content` 端点获取（见第 12 节）。

### 5.3 经典分类列表

```
GET /api/sutras/categories
```

**响应（200）：**

```json
["般若部", "法华部", "涅槃部", "华严部", "阿含部", "禅宗经典"]
```

---

## 6. 佛学词典 API — ✅ 已实现

> 端点位置：`src/app/api/glossary/`

### 6.1 词条列表

```
GET /api/glossary
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `letter` | string | 否 | 首字母筛选（如 "般"） |
| `page` | integer | 否 | 页码，默认 1 |
| `pageSize` | integer | 否 | 每页条数，默认 20 |

**响应（200）：**

```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "prajna",
      "term": "般若",
      "termEn": "Prajñā",
      "termSanskrit": "प्रज्ञा",
      "definition": "梵语 prajñā 的音译，意为智慧。特指能够通达诸法实相的超越智慧。",
      "relatedTerms": ["菩提", "空性", "六度"],
      "createdAt": "2026-06-24T00:00:00.000Z"
    }
  ],
  "total": 120,
  "page": 1,
  "pageSize": 20,
  "totalPages": 6
}
```

### 6.2 词条详情

```
GET /api/glossary/{slug}
```

**响应（200）：**

```json
{
  "id": "uuid",
  "slug": "prajna",
  "term": "般若",
  "termEn": "Prajñā",
  "termSanskrit": "प्रज्ञा",
  "definition": "梵语 prajñā 的音译，意为智慧。特指能够通达诸法实相的超越智慧。",
  "relatedTerms": ["菩提", "空性", "六度"],
  "createdAt": "2026-06-24T00:00:00.000Z"
}
```

---

## 7. 佛学百科 API — ✅ 已实现

> 端点位置：`src/app/api/encyclopedia/`

### 7.1 百科条目列表

```
GET /api/encyclopedia
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `category` | string | 否 | 分类筛选：人物 / 宗派 / 经典 / 历史 |
| `page` | integer | 否 | 页码，默认 1 |
| `pageSize` | integer | 否 | 每页条数，默认 20 |

**响应（200）：**

```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "nagarjuna",
      "title": "龙树",
      "category": "人物",
      "content": "龙树（Nāgārjuna，约公元150—250年），大乘佛教中观学派创始人...",
      "createdAt": "2026-06-24T00:00:00.000Z"
    }
  ],
  "total": 50,
  "page": 1,
  "pageSize": 20,
  "totalPages": 3
}
```

### 7.2 百科条目详情

```
GET /api/encyclopedia/{slug}
```

**响应（200）：**

```json
{
  "id": "uuid",
  "slug": "nagarjuna",
  "title": "龙树",
  "category": "人物",
  "content": "龙树（Nāgārjuna，约公元150—250年），大乘佛教中观学派创始人...",
  "createdAt": "2026-06-24T00:00:00.000Z"
}
```

### 7.3 百科分类列表

```
GET /api/encyclopedia/categories
```

**响应（200）：**

```json
["人物", "宗派", "经典", "历史"]
```

---

## 8. 佛经故事 API — ✅ 已实现

> 端点位置：`src/app/api/stories/`

### 8.1 故事列表

```
GET /api/stories
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `category` | string | 否 | 分类筛选：本生故事 / 因缘故事 / 譬喻故事 / 禅宗公案 / 佛陀传记 |
| `page` | integer | 否 | 页码，默认 1 |
| `pageSize` | integer | 否 | 每页条数，默认 20 |

**响应（200）：**

```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "nine-colored-deer",
      "title": "九色鹿",
      "titleEn": "The Nine-Colored Deer",
      "category": "本生故事",
      "sourceSutra": "九色鹿经",
      "summary": "佛陀前世曾为一只九色鹿，救起落水之人，反遭背叛...",
      "content": "昔日，佛陀于舍卫国祇树给孤独园...（完整故事正文）...",
      "moral": "知恩图报、诚信为人之本",
      "imageUrl": null,
      "createdAt": "2026-06-24T00:00:00.000Z"
    }
  ],
  "total": 30,
  "page": 1,
  "pageSize": 20,
  "totalPages": 2
}
```

### 8.2 故事详情

```
GET /api/stories/{slug}
```

**响应（200）：** 同列表项结构（单个对象）

### 8.3 故事分类列表

```
GET /api/stories/categories
```

**响应（200）：**

```json
["本生故事", "因缘故事", "譬喻故事", "禅宗公案", "佛陀传记"]
```

---

## 9. 佛教时间线 API — ✅ 已实现

> 端点位置：`src/app/api/timeline/`

### 9.1 时间线事件列表

```
GET /api/timeline
```

**响应（200）：**

```json
[
  {
    "id": "uuid",
    "slug": "buddha-parinirvana",
    "year": -483,
    "yearDisplay": "约 公元前 483 年",
    "title": "佛陀涅槃",
    "description": "佛陀在拘尸那揭罗城娑罗双树间入灭...",
    "category": "人物",
    "location": "拘尸那揭罗",
    "createdAt": "2026-06-24T00:00:00.000Z"
  },
  {
    "id": "uuid",
    "slug": "xuanzang-journey",
    "year": 645,
    "yearDisplay": "645 年",
    "title": "玄奘法师归国",
    "description": "玄奘法师自天竺归长安，带回佛经657部...",
    "category": "历史事件",
    "location": "长安",
    "createdAt": "2026-06-24T00:00:00.000Z"
  }
]
```

**说明：**
- 按年份升序排列
- `year` 为整数，负数表示公元前
- 分类包括：人物 / 经典译出 / 宗派创立 / 历史事件 / 圣地

---

## 10. 学习路径 API — ✅ 已实现

> 端点位置：`src/app/api/paths/`

### 10.1 学习路径列表

```
GET /api/paths
```

**响应（200）：**

```json
[
  {
    "id": "uuid",
    "slug": "buddhism-intro",
    "title": "佛学入门",
    "description": "从零开始了解佛教基本概念与核心教义...",
    "level": "Beginner",
    "levelLabel": "入门",
    "icon": "🌱",
    "stepCount": 7,
    "createdAt": "2026-06-24T00:00:00.000Z"
  },
  {
    "id": "uuid",
    "slug": "four-noble-truths",
    "title": "四圣谛",
    "description": "深入理解苦、集、灭、道四圣谛...",
    "level": "Intermediate",
    "levelLabel": "进阶",
    "icon": "🔍",
    "stepCount": 5,
    "createdAt": "2026-06-24T00:00:00.000Z"
  }
]
```

### 10.2 学习路径详情（含步骤）

```
GET /api/paths/{slug}
```

**响应（200）：**

```json
{
  "path": {
    "id": "uuid",
    "slug": "buddhism-intro",
    "title": "佛学入门",
    "description": "从零开始了解佛教基本概念与核心教义...",
    "level": "Beginner",
    "levelLabel": "入门",
    "icon": "🌱",
    "stepCount": 7,
    "createdAt": "2026-06-24T00:00:00.000Z"
  },
  "steps": [
    {
      "id": "uuid",
      "pathId": "uuid",
      "stepNumber": 1,
      "title": "佛陀的一生",
      "description": "了解释迦牟尼佛从出生到涅槃的生命历程",
      "guidance": "建议先阅读《佛所行赞》或相关传记",
      "relatedSutraSlugs": ["buddha-biography"],
      "relatedTermSlugs": ["buddha", "nirvana"],
      "createdAt": "2026-06-24T00:00:00.000Z"
    }
  ]
}
```

---

## 11. 收藏 API — ✅ 已实现

> 端点位置：`src/app/api/favorites/`
>
> ⚠️ **所有收藏接口均需登录。**

### 11.1 获取我的收藏

```
GET /api/favorites
```

需要登录：✅

**响应（200）：**

```json
[
  {
    "id": "uuid",
    "userId": "user-id",
    "type": "sutra",
    "slug": "diamond-sutra",
    "title": "金刚般若波罗蜜经",
    "subtitle": "般若部",
    "createdAt": "2026-06-24T00:00:00.000Z"
  },
  {
    "id": "uuid",
    "userId": "user-id",
    "type": "glossary",
    "slug": "prajna",
    "title": "般若",
    "subtitle": "Prajñā",
    "createdAt": "2026-06-26T00:00:00.000Z"
  }
]
```

### 11.2 切换收藏状态（添加/取消）

```
POST /api/favorites
```

需要登录：✅

**请求体：**

```json
{
  "type": "sutra",
  "slug": "diamond-sutra",
  "title": "金刚般若波罗蜜经",
  "subtitle": "般若部（可选）"
}
```

**响应（200）：**

```json
{
  "favorited": true
}
```

或

```json
{
  "favorited": false
}
```

**说明：** 如果已收藏则取消收藏，未收藏则添加收藏。`favorited` 表示操作后的状态。

### 11.3 移除收藏

```
DELETE /api/favorites/{id}
```

需要登录：✅

**响应（200）：**

```json
{
  "success": true
}
```

**说明：** `{id}` 为收藏记录的 ID（从 "获取我的收藏" 返回值中获得）。

### 11.4 检查收藏状态

```
GET /api/favorites/check?type={type}&slug={slug}
```

需要登录：✅

**响应（200）：**

```json
{
  "favorited": true
}
```

---

## 12. 经典正文 API — ✅ 已实现

> 端点位置：`src/app/api/sutras/[slug]/content/`

### 12.1 获取经典正文

```
GET /api/sutras/{slug}/content
```

**响应（200）：**

```json
{
  "slug": "diamond-sutra",
  "title": "金刚般若波罗蜜经",
  "content": "# 金刚般若波罗蜜经\n\n## 第一品 法会因由分\n\n如是我闻...（Markdown 格式全文）",
  "format": "markdown"
}
```

**说明：** 返回 MDX 正文去除 frontmatter 后的 Markdown 内容，Flutter 侧可用 Markdown 渲染组件展示。

---

## 13. 数据模型参考

### 13.1 Sutra（经典）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `slug` | string | URL 标识符，如 `diamond-sutra` |
| `title` | string | 中文标题 |
| `titleEn` | string? | 英文/梵文标题 |
| `dynasty` | string? | 朝代，如 "唐" |
| `translator` | string? | 译者，如 "鸠摩罗什" |
| `summary` | string? | 简介摘要 |
| `category` | string? | 分类，如 "般若部" |
| `cbetaId` | string? | CBETA 编号 |
| `satId` | string? | SAT 编号 |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.2 Glossary（词典词条）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `slug` | string | URL 标识符 |
| `term` | string | 中文术语 |
| `termEn` | string? | 英文翻译 |
| `termSanskrit` | string? | 梵文 |
| `definition` | string | 释义 |
| `relatedTerms` | string[]? | 相关术语列表 |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.3 Encyclopedia（百科条目）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `slug` | string | URL 标识符 |
| `title` | string | 标题 |
| `category` | string? | 分类：人物 / 宗派 / 经典 / 历史 |
| `content` | string | 正文内容 |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.4 Story（佛经故事）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `slug` | string | URL 标识符 |
| `title` | string | 故事标题 |
| `titleEn` | string? | 英文标题 |
| `category` | string | 分类 |
| `sourceSutra` | string? | 出处经典 |
| `summary` | string | 故事概要 |
| `content` | string | 故事正文 |
| `moral` | string? | 寓意/启示 |
| `imageUrl` | string? | 配图 URL |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.5 TimelineEvent（时间线事件）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `slug` | string | URL 标识符 |
| `year` | integer | 年份（负数=公元前） |
| `yearDisplay` | string | 年份显示文本 |
| `title` | string | 事件标题 |
| `description` | string | 事件描述 |
| `category` | string | 分类：人物 / 经典译出 / 宗派创立 / 历史事件 / 圣地 |
| `location` | string? | 地点 |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.6 LearningPath（学习路径）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `slug` | string | URL 标识符 |
| `title` | string | 路径标题 |
| `description` | string | 路径描述 |
| `level` | string | 难度：Beginner / Intermediate / Advanced |
| `levelLabel` | string | 中文标签：入门 / 进阶 / 深入 |
| `icon` | string | Emoji 图标 |
| `stepCount` | integer | 步骤总数 |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.7 PathStep（学习步骤）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `pathId` | UUID | 所属路径 ID |
| `stepNumber` | integer | 步骤序号 |
| `title` | string | 步骤标题 |
| `description` | string? | 步骤描述 |
| `guidance` | string? | 学习指导 |
| `relatedSutraSlugs` | string[]? | 关联经典 slug |
| `relatedTermSlugs` | string[]? | 关联术语 slug |
| `createdAt` | string | 创建时间（ISO 8601） |

### 13.8 Favorite（收藏）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | UUID | 主键 |
| `userId` | string | 用户 ID |
| `type` | string | 类型：`sutra` / `glossary` / `story` / `encyclopedia` |
| `slug` | string | 对应内容的 slug |
| `title` | string | 收藏标题（冗余存储，方便展示） |
| `subtitle` | string? | 副标题（如分类、梵文等） |
| `createdAt` | string | 收藏时间（ISO 8601） |

### 13.9 User（用户）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | string | 用户 ID |
| `email` | string | 邮箱 |
| `emailVerified` | boolean | 邮箱是否已验证 |
| `name` | string? | 用户昵称 |
| `image` | string? | 头像 URL |
| `createdAt` | string | 注册时间（ISO 8601） |
| `updatedAt` | string? | 更新时间（ISO 8601） |

---

## 14. API 端点总览

| # | 端点 | 方法 | 状态 | 需要登录 |
|---|------|------|------|----------|
| 1 | `/api/auth/[...all]` | GET/POST | ✅ | — |
| 2 | `/api/search` | GET | ✅ | ❌ |
| 3 | `/api/poster/{type}/{slug}` | GET | ✅ | ❌ |
| 4 | `/api/sutras` | GET | ✅ | ❌ |
| 5 | `/api/sutras/{slug}` | GET | ✅ | ❌ |
| 6 | `/api/sutras/{slug}/content` | GET | ✅ | ❌ |
| 7 | `/api/sutras/categories` | GET | ✅ | ❌ |
| 8 | `/api/glossary` | GET | ✅ | ❌ |
| 9 | `/api/glossary/{slug}` | GET | ✅ | ❌ |
| 10 | `/api/encyclopedia` | GET | ✅ | ❌ |
| 11 | `/api/encyclopedia/{slug}` | GET | ✅ | ❌ |
| 12 | `/api/encyclopedia/categories` | GET | ✅ | ❌ |
| 13 | `/api/stories` | GET | ✅ | ❌ |
| 14 | `/api/stories/{slug}` | GET | ✅ | ❌ |
| 15 | `/api/stories/categories` | GET | ✅ | ❌ |
| 16 | `/api/timeline` | GET | ✅ | ❌ |
| 17 | `/api/paths` | GET | ✅ | ❌ |
| 18 | `/api/paths/{slug}` | GET | ✅ | ❌ |
| 19 | `/api/favorites` | GET | ✅ | ✅ |
| 20 | `/api/favorites` | POST | ✅ | ✅ |
| 21 | `/api/favorites/{id}` | DELETE | ✅ | ✅ |
| 22 | `/api/favorites/check` | GET | ✅ | ✅ |

---

## 15. 已实现文件结构

所有 22 个端点均已实现，文件结构如下：

```
src/app/api/
├── auth/[...all]/route.ts        ← Better Auth (GET/POST)
├── search/route.ts               ← 全局搜索 (GET)
├── poster/[type]/[slug]/route.tsx ← 分享海报 (GET)
├── sutras/
│   ├── route.ts                  ← 经典列表 (GET)
│   ├── categories/route.ts       ← 经典分类 (GET)
│   └── [slug]/
│       ├── route.ts              ← 经典详情 (GET)
│       └── content/route.ts      ← 经典正文 (GET)
├── glossary/
│   ├── route.ts                  ← 词条列表 (GET)
│   └── [slug]/route.ts           ← 词条详情 (GET)
├── encyclopedia/
│   ├── route.ts                  ← 百科列表 (GET)
│   ├── categories/route.ts       ← 百科分类 (GET)
│   └── [slug]/route.ts           ← 百科详情 (GET)
├── stories/
│   ├── route.ts                  ← 故事列表 (GET)
│   ├── categories/route.ts       ← 故事分类 (GET)
│   └── [slug]/route.ts           ← 故事详情 (GET)
├── timeline/route.ts             ← 时间线 (GET)
├── paths/
│   ├── route.ts                  ← 路径列表 (GET)
│   └── [slug]/route.ts           ← 路径详情+步骤 (GET)
└── favorites/
    ├── route.ts                  ← 收藏列表 (GET) + 切换 (POST)
    ├── check/route.ts            ← 收藏状态 (GET)
    └── [id]/route.ts             ← 移除收藏 (DELETE)
```

### Flutter 侧建议

- 使用 `dio` 或 `http` 包进行网络请求
- Cookie 管理：登录后保存 Cookie，后续请求自动携带（或用 `cookie_jar` 包）
- 图片缓存：海报 API 返回 24h 缓存，Flutter 侧可用 `cached_network_image`
- Markdown 渲染：经典正文返回 Markdown，Flutter 侧推荐 `flutter_markdown`
