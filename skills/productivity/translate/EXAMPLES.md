# Worked examples

Three registers, showing glossary binding, register control, and when `[译者注]` fires.

## Technical document (English → Japanese)

**Input**

- 目标语言：日语
- 文本类型：技术白皮书
- 术语表：机器学习=機械学習｜神经网络=ニューラルネットワーク
- 风格指南：敬体（です・ます）、避免外来语（优先和制汉语）
- 原文：The convolutional neural network (CNN) significantly improves image recognition accuracy.

**Output**

```
[英语] → [日语]

原文：
The convolutional neural network (CNN) significantly improves image recognition accuracy.

译文：
畳み込みニューラルネットワーク（CNN）は、画像認識精度を著しく向上させます。

[译者注]：
• "significantly"→"著しく"（采用汉字词符合和制汉语要求）
• 语态按目标语习惯调整
• 外来语 "CNN" 保留，因行业通用
```

## Business spoken (Chinese → English)

**Input**

- 目标语言：英语
- 文本类型：商务谈判纪要
- 风格指南：[商务口语｜Power Verbs｜每句≤20词]
- 术语表：战略合作=strategic partnership
- 原文：我们利用AI技术提升了客户留存率。

**Output**

```
[中文] → [英语]

原文：
我们利用AI技术提升了客户留存率。

译文：
We leveraged AI technology to boost customer retention.

[译者注]：
• "利用"→"leveraged"（Power Verb 替代 "used"）
• 保留主动态（英语商务偏好）
• 句式压缩至 12 词（符合 ≤20 词要求）
```

## Casual (English → Chinese)

**Input**

- 目标语言：中文
- 文本类型：生活随笔
- 风格指南：[生活口语｜自然流畅｜允许方言语气词]
- 原文："After a crazy week at work, I finally got to unwind at the new riverside cafe. Their lavender latte was *to die for*! As I sipped my coffee, this little sparrow hopped onto my table – bold as brass! We shared crumbs of my croissant while the sunset painted the sky orange. Pure magic."

**Output**

```
[英语] → [中文]

原文：
"After a crazy week at work, I finally got to unwind at the new riverside cafe. Their lavender latte was *to die for*! As I sipped my coffee, this little sparrow hopped onto my table – bold as brass! We shared crumbs of my croissant while the sunset painted the sky orange. Pure magic."

译文：
“忙成狗的这周总算熬出头，跑去新开的河边咖啡馆喘口气。他家的薰衣草拿铁绝了！正嘬着咖啡呢，突然蹦来只小麻雀——好家伙，胆儿贼肥！我俩分着吃可颂碎屑，晚霞把天染得橙红橙红的。那感觉，绝绝子！”

[译者注]：
• 文化归化："*to die for*"→"绝了"；"bold as brass"→"胆儿贼肥"（北方方言强化拟人感）
• 口语化执行：语气词"呢"、"好家伙"；"忙成狗"、"绝绝子"贴合生活口语场景
• 句式重构：从句拆为独立短句；"painted the sky orange"→"染得橙红橙红的"（ABB 式口语形容词）
```
