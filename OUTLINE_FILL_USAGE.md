# 目录填充符号自定义功能

## 功能说明

该功能允许用户自定义目录（outline）中标题和页码之间的填充符号。

## 使用方法

在调用 `ori` 函数时，通过 `outline-fill` 参数指定填充符号：

```typst
#show: ori.with(
  makeoutline: true,
  outline-fill: repeat[—],  // 自定义填充符号
  // ... 其他参数
)
```

## 参数说明

- **参数名**: `outline-fill`
- **类型**: content（通常使用 `repeat[]` 函数）
- **默认值**: `repeat[.]` （点状填充）
- **作用**: 控制目录中标题与页码之间的填充内容

## 常用填充符号示例

### 1. 默认点填充（保持原样）
```typst
outline-fill: repeat[.]
```

### 2. 破折号填充
```typst
outline-fill: repeat[-]
```

### 3. 中点填充
```typst
outline-fill: repeat[·]
```

### 4. 长破折号填充
```typst
outline-fill: repeat[—]
```

### 5. 空格填充（无填充）
```typst
outline-fill: repeat[ ]
```

## 完整示例

```typst
#import "book.typ": ori

#show: ori.with(
  makeoutline: true,
  outline-depth: 3,
  outline-fill: repeat[—],
  title: "我的文档",
  subject: "示例科目",
)

= 第一章
== 第一节
= 第二章
```

## 技术说明

本功能使用 Typst 0.13+ 的 `set outline.entry(fill: ...)` 语法实现，兼容 Typst 0.14.0 版本。
