// ============================================
// 导入各种第三方包，就像 Python 里的 import 一样
// ============================================

#import "@preview/numbly:0.1.0": numbly // 用来搞定列表编号的
#import "@preview/tablem:0.3.0": tablem, three-line-table // 画三线表的工具
// ============================================
// 默认字体配置 - 中英文混排的字体搭配方案
// ============================================
#let default-font = (
main: "Lato", // 英文主字体，一款很清爽的无衬线字体
mono: "Fira Code", // 代码字体，程序员最爱，带连字符
cjk: "Noto Sans SC", // 中文字体（简体中文）
emph-cjk: "KaiTi", // 中文强调字体，用楷体，很有感觉
math: "Lete Sans Math", // 数学公式用的字体
math-cjk: "Noto Sans SC", // 数学公式里的中文字体
)

// ============================================
// 核心模板函数 - 这是整个模板的大脑
// ============================================
/// 这个函数定义了整个文档的外观和格式
///
/// 参数说明（都是可选的，不传就用默认值）：
/// - media: 媒体类型
/// * "print" = 打印版（A4纸，标准边距）
/// * "screen" = 屏幕版（小边距，适合电子阅读）
/// - theme: 主题配色
/// * "light" = 亮色主题（白底黑字）
/// * "dark" = 暗色主题（黑底白字，护眼）
/// - size: 打印版字号，默认 11pt
/// - screen-size: 屏幕版字号，默认 11pt
/// - title: 文档标题，比如"期末复习笔记"
/// - author: 作者名字
/// - subject: 科目名称，比如"高等数学"
/// - semester: 学期，比如"2024春季学期"
/// - date: 日期
/// - font: 字体配置，可以覆盖默认字体
/// - first-line-indent: 段首缩进设置
/// * amount: 缩进多少（0pt = 不缩进）
/// * all: 是否所有段落都缩进（false = 标题后第一段不缩进）
/// - maketitle: 是否生成标题页（true/false）
/// - makeoutline: 是否生成目录（true/false）
/// - outline-depth: 目录深度（2 = 显示到二级标题）
/// - body: 文档正文内容
#let ori(
media: "print",
theme: "light

",
size: 11pt,
screen-size: 11pt,
title: none,
author: none,
subject: none,
semester: none,
date: none,
font: default-font,
lang: "zh",
region: "cn",
first-line-indent: (amount: 0pt, all: false),
maketitle: false,
makeoutline: false,
outline-depth: 2,
body,
) = {
// --------------------------------------------
// 根据媒体类型设置页边距
// --------------------------------------------
// 屏幕版用小边距（35pt），打印版用自动边距（标准A4边距）
let page-margin = if media == "screen" { (x: 35pt, y: 35pt) } else { auto }

// --------------------------------------------
// 根据媒体类型选择字号
// --------------------------------------------
let text-size = if media == "screen" { screen-size } else { size }

// --------------------------------------------
// 根据主题设置配色方案
// --------------------------------------------
let bg-color = if theme == "dark" { rgb("#1f1f1f") } else { rgb("#ffffff") } // 背景色
let text-color = if theme == "dark" { rgb("#ffffff") } else { rgb("#000000") } // 文字颜色
let raw-color = if theme == "dark" { rgb("#27292c") } else { rgb("#f0f0f0") } // 代码块背景色

// --------------------------------------------
// 合并用户自定义字体和默认字体
// --------------------------------------------
let font = default-font + font // 用户传的字体会覆盖默认字体

// ============================================
// 全局文本设置
// ============================================
/// 设置整个文档的字体、字号、颜色
set text(
font: ((name: font.main, covers: "latin-in-cjk"), font.cjk), // 中英文混排：英文用 main，中文用 cjk
size: text-size, // 字号
fill: text-color, // 文字颜色
lang: lang, // 语言（影响连字符、换行规则）
region: region, // 地区（影响排版细节）
)

// --------------------------------------------
// 强调文本（斜体）用楷体
// --------------------------------------------
show emph: text.with(font: ((name: font.main, covers: "latin-in-cjk"), font.emph-cjk))

// --------------------------------------------
// 代码用等宽字体
// --------------------------------------------
show raw: set text(font: ((name: font.mono, covers: "latin-in-cjk"), font.cjk))

// --------------------------------------------
// 数学公式的字体设置
// --------------------------------------------
show math.equation: it => {
set text(font: font.math) // 数学公式主字体
show regex("\p{script=Han}"): set text(font: font.math-cjk) // 公式里的汉字用中文字体
it
}

// ============================================
// 段落样式设置
// ============================================
/// 设置段落的对齐和缩进
set par(
justify: true, // 两端对齐（像 Word 里的"分散对齐"）
first-line-indent: if first-line-indent == auto {
(amount: 2em, all: true) // 自动模式：所有段落首行缩进2字符
} else {
first-line-indent // 用户自定义缩进
},
)

// ============================================
// 标题样式设置
// ============================================
show heading: it => {
show h.where(amount: 0.3em): none // 去掉标题前的一点空白
it
}
show heading: set block(spacing: 1.2em) // 标题前后留 1.2em 的空白

// ============================================
// 代码块样式设置
// ============================================

// --------------------------------------------
// 行内代码（比如 print("hello")）
// --------------------------------------------

show raw.where(block: false): body => box(
fill: raw-color, // 背景色
inset: (x: 3pt, y: 0pt), // 内边距：左右3pt，上下0pt
outset: (x: 0pt, y: 3pt), // 外边距：左右0pt，上下3pt（让代码不会太贴着文字）
radius: 2pt, // 圆角2pt（看起来更圆润）
{
set par(justify: false) // 代码不要两端对齐
body
},
)

// --------------------------------------------
// 代码块（多行代码）
// --------------------------------------------
show raw.where(block: true): body => block(
width: 100%, // 占满整行
fill: raw-color, // 背景色
outset: (x: 0pt, y: 4pt), // 外边距
inset: (x: 8pt, y: 4pt), // 内边距：左右8pt（让代码不贴边）
radius: 4pt, // 圆角4pt
{
set par(justify: false) // 代码不要两端对齐
body
},
)

// ============================================
// 链接样式设置
// ============================================
show link: it => {
if type(it.dest) == str { // 如果是外部链接（http://...）
set text(fill: blue) // 显示成蓝色
it
} else { // 如果是内部引用（比如引用公式）
it // 保持原样
}
}

// ============================================
// 图表样式设置
// ============================================
show figure.where(kind: table): set figure.caption(position: top) // 表格标题放在上面（学术规范）

// ============================================
// 列表样式设置
// ============================================
set list(indent: 6pt) // 无序列表缩进6pt
set enum(indent: 6pt) // 有序列表缩进6pt
set enum(numbering: numbly("{1:1}.", "{2:1})", "{3:a}."), full: true)
// 有序列表编号：
// 一级用 "1."
// 二级用 "1)"
// 三级用 "a."

// ============================================
// 参考文献样式
// ============================================
set bibliography(style: "ieee") // 用 IEEE 格式（计算机类常用）

// ============================================
// 文档元数据
// ============================================
set document(
title: title, // 设置PDF的标题元数据
author: if type(author) == str { author } else { () }, // 设置作者（如果有的话）
date: date // 设置日期
)

// ============================================
// 生成标题页（可选）
// ============================================
if maketitle {
align(center + top)[ // 居中对齐，靠上
#v(20%) // 从顶部往下空20%的页面高度
#text(2em, weight: 500, subject) // 显示科目名，字号2em，中等粗细
#v(2em, weak: true)

// 空2em（弹性间距，可以被压缩）
#text(2em, weight: 500, title) // 显示标题
#v(2em, weak: true) // 空2em
#author // 显示作者
]
pagebreak(weak: true) // 换页（如果后面没内容就不换）
}

// ============================================
  // 生成目录
  // ============================================
  if makeoutline {
    show heading: align.with(center) // 目录页的标题居中
    show outline.entry: it => {
      // 获取当前目录项所在的位置信息
      let loc = it.element.location()
      // 获取该位置对应的页码（使用页面计数器）
      let page-num = counter(page).at(loc).first()

      // 获取标题的编号格式（如 "1.", "1.1." 等）
      let heading-numbering = it.element.numbering
      // 根据编号格式生成实际的标题编号
      let heading-number = if heading-numbering != none {
        numbering(heading-numbering, ..counter(heading).at(loc))
      }

      // 使用 grid 布局来实现三列式的目录条目
      block(
        spacing: 1.2em, // 目录项之间的垂直间距
        grid(
          columns: (auto, 1fr, auto), // 三列布局：左列自适应宽度，中列占满剩余空间，右列自适应宽度
          column-gutter: 1.5em, // 列之间的间距
          align: (left, horizon, right), // 对齐方式：左列左对齐，中列垂直居中，右列右对齐
          {
            // 第一列：标题文本（带缩进和链接）
            h(it.level * 2em) // 根据标题层级进行缩进（一级标题缩进0，二级缩进2em，三级缩进4em...）
            link(loc)[ // 创建可点击的链接，点击可跳转到对应标题
              #if heading-number != none {
                heading-number // 显示标题编号（如 "1.1"）
                h(0.5em) // 编号和标题之间留0.5em间距
              }
              #it.element.body // 显示标题的文本内容
            ]
          },
          // 第二列：引导点（垂直居中的点线）
          align(horizon, repeat[$dot$~]), // horizon让点线垂直居中，repeat[$dot$~]生成连续的点线
          // 第三列：页码（右对齐的链接）
          link(loc, str(page-num)) // 创建可点击的页码链接，点击可跳转到对应页面
        )
      )
    }
    outline(depth: outline-depth, indent: 2em) // 生成目录，设置目录深度和默认缩进

    pagebreak(weak: true)                      // 目录后换页（弱换页，如果后面没内容就不强制换页）
  }

// ============================================
// 重置页码
// ============================================

counter(page).update(1) // 正文从第1页开始计数

// ============================================
// 页面设置（页眉、页码、边距等）
// ============================================
set page(
paper: "a4", // A4纸张
header: { // 页眉设置
set text(0.9em) // 页眉字号小一点
stack( // 垂直堆叠元素
spacing: 0.2em,
grid( // 三栏布局
columns: (1fr, auto, 1fr), // 左右两栏自适应，中间固定
align(left, semester), // 左边显示学期
align(center, subject), // 中间显示科目
align(right, title), // 右边显示标题
),
v(0.3em), // 空0.3em
line(length: 100%, stroke: 1pt + text-color), // 粗线（1pt）
v(.15em), // 空0.15em
line(length: 100%, stroke: .5pt + text-color), // 细线（0.5pt）
)
// 每页重置脚注计数器（脚注编号每页从1开始）
counter(footnote).update(0)
},
fill: bg-color, // 页面背景色
numbering: "1", // 页码样式：阿拉伯数字
margin: page-margin, // 页边距
)

// ============================================
// 渲染正文内容
// ============================================
body
}
