#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.3.0": *
#import "@preview/zebraw:0.6.3": *
#set page(
    margin: (x: 2cm, y: 2cm),
    paper: "a4", 
    numbering: "1",
    )
#set text(font: "Microsoft YaHei")
#set heading(numbering: numbly(
  "{1:一}、",
  "{2:1}.",
  "{3:a}.",
))
#show: zebraw-init.with(
    lang: false,
    comment-font-args: (
    font: "Microsoft YaHei",style: "italic"),
    highlight-color: blue.lighten(90%),
    comment-color: yellow.lighten(90%),
    radius: 10pt,
    background-color: luma(94.5%),
    indentation: 2
    ) 

#show heading: it => {
  if(it.level == 1) {
    block(
    above : 2.5em,
    below : 1.5em,
    it
)
  } else if(it.level == 2) {
    block(
    above : 1.5em,
    below : 1.0em,
    it
)
  } else if(it.level == 3) {
    block(
    above : 1.0em,
    below : 1.0em,
    it
)
  }
}



#set par(
  justify: true,
  leading: 1.4em,
  first-line-indent: (
    amount: 1em,
    all: true
  )
)

// 封面
#align(center)[
  #v(8cm)
  #text(size: 30pt, weight: "bold")[《高级程序设计与实践》]  \
  
  #text(size: 26pt, weight: "bold")[万年历程序设计说明]
  #v(4cm)
  /*#{
  
  set text(size: 20pt, weight: "bold")
  
  table(
    inset: 7pt,
    columns: 2,
    stroke: none,
    [班级：],[自动化5班],
    [学号：],[202500171246],
    [姓名：],[佘书宇],

  )}
*/ 
  
  
]
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[目录]
]

#v(1.5em)

#{
  set par(leading:3em)
  outline(
  title: none,
  depth: 2,
  indent: auto
)
}

#pagebreak()
#align(center)[
  #v(1.5em)
  #text(size: 16pt,weight: "bold")[控制科学与工程学院]
  #v(1em)
  #text(size: 16pt, weight: "bold")[课程设计题目]
]
#v(1.5em)

= 问题描述

输入任意的年份，输出该年份的日历。

= 基本要求

输入年份，输出日历。显示公元后任何年份的日历，日历以月份顺序排列，每月以星期顺序排列，类似于一般挂历上的格式,参考格式如下：\




#block(inset: (left: 1.5cm,right: 6cm))[

  #set text(size:9pt)
  输入年份:2025
  #v(10pt)
  #align(center)[2025 年]
  #v(5pt)

 
  #box(width: 100%, stroke: (dash: "dashed", thickness: 0.5pt))[]
  #v(5pt)

  // ---------------- 一月 ----------------
  #v(5pt)
  #align(center)[一月]

  #grid(
    columns: 7,
    align: center,
    gutter: 13pt,

    "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六",
    "", "", "", "1", "2", "3", "4",
    "5", "6", "7", "8", "9", "10", "11",
    "12", "13", "14", "15", "16", "17", "18",
    "19", "20", "21", "22", "23", "24", "25",
    "26", "27", "28", "29", "30", "31", ""
  )
  #v(5pt)
  #box(width: 100%, stroke: (dash: "dashed", thickness: 0.5pt))[]
  #v(5pt)

  // ---------------- 二月 ----------------
  #v(5pt)
  #align(center)[二月]

  #grid(
    columns: 7,
    align: center,
    gutter: 13pt,
    "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六",
    "", "", "", "", "", "", "1",
    "2", "3", "4", "5", "6", "7", "8",
    "9", "10", "11", "12", "13", "14", "15",
    "16", "17", "18", "19", "20", "21", "22",
    "23", "24", "25", "26", "27", "28", ""
  )
  #v(5pt)
  #box(width: 100%, stroke: (dash: "dashed", thickness: 0.5pt))[]
  #v(5pt)

  #align(center)[
    ...
    #v(5pt)
    ...
    #v(5pt)
    ...
    #v(5pt)
  ]
  #box(width: 100%, stroke: (dash: "dashed", thickness: 0.5pt))[]
  #v(5pt)

  // ---------------- 十二月 ----------------
  #v(5pt)
  #align(center)[十二月]
  
  #grid(
    columns: 7,
    align: center,
    gutter: 13pt,
    "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六",
    "", "1", "2", "3", "4", "5", "6",
    "7", "8", "9", "10", "11", "12", "13",
    "14", "15", "16", "17", "18", "19", "20",
    "21", "22", "23", "24", "25", "26", "27",
    "28", "29", "30", "31", "", "", ""
  )
  #v(5pt)
  #box(width: 100%, stroke: (dash: "dashed", thickness: 0.5pt))[]
  #v(5pt)
  请按任意键继续. . .
]



= 工具/准备工作 
vscode

= 分析与实现
== 题目分析
要通过输入年份，输出该年份的日历，可以计算出从公元1年1月1日到输入年份每个月1日的天数，因为公元1月1日被规定为星期六，所以通过(总天数+5)%7的值就可以得到每个月1日是星期几，然后就可以依次输出每个月的日历了。

但是由于历史上的1582年10月4日这一天，历法由儒略历改成了格里高利历，1582年10月5日到1582年10月14日这10天直接消失，
而且闰年的判断方法也由直接判断4的倍数，变成了现在的更完善的判断方法，所以日期转换到天数的算法要考虑这一点。

#pagebreak()
== 代码实现
=== 创建日期类
- 创建一个日期类，用于表示日期
#let code= ```cpp
class Date {
private:
    int year;
    int month;
    int day;
public:
    Date(int y = 1, int m = 1, int d = 1){
        if(y==1582 && m==10 && d>=5 && d<=14){ 
            year = 1582;
            month = 10;
            day = d + 10;
        } else {
            year = y;
            month = m;
            day = d;
        } 
    }
    
    int GetYear() const { return year; }
    int GetMonth() const { return month; }
    int GetDay() const { return day; }

    static int GetMonthDays(int year,int month);
    static int DateToNum(const Date &d);
    static int Week(const Date &d);
    static Date NumToDate(int n);
    
    Date operator+(int days) const;
    Date operator-(int days) const;
    bool operator<(const Date &other) const;
    bool operator<=(const Date &other) const;
    bool operator>(const Date &other) const;
};
```
#zebraw(line-range:(1,18),
code,highlight-lines:(
  ..range(2,6),(5,[定义 year month day 成员变量]),
  ..range(7,18),(17,[构造函数，直接忽略1582年10月5日到1582年10月14日这10天])))

- 成员函数
#zebraw(line-range:(19,34),code,highlight-lines:(
  ..range(19,22),(21,[方便访问私有成员变量]),
  ..range(23,26),(26,[先在结构体内声明成员函数，之后再在外部写函数内容]),
  ..range(28,33),(33,[重载运算符，方便日期间加减比较])))
=== 闰年判断函数
#block(inset: (left: 1.0em))[
+ 格里高利历(1582年10月4日之后)：\ 
  - 4的倍数，但不是100的倍数\ 
  - 或者400的倍数
+ 儒略历：\ 
  - 只需要是4的倍数]
#zebraw(
```cpp
bool IsLeapYear(int y) {
    if (y > 1582)
        return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
    else
        return y % 4 == 0;
}
```
)
=== 获取具体年份天数函数
#block(inset: (left: 1.0em))[
- 1582年由于是平年且消失10天，所以只有有355天 
- 其他年份根据闰年和平年来计算]
#zebraw(
```cpp
int GetYearDays(int y) {
    if (y == 1582) return 355;
    return IsLeapYear(y) ? 366 : 365;
}
```
)
=== 获取具体月份天数函数
#block(inset: (left: 1.0em))[
- 1582年10月只有21天
- 2月天数根据平闰年判断
- 定义天数数组{0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}，\直接返回对应月份的天数]
#zebraw(

```cpp
int Date::GetMonthDays(int year,int month) {
    if (year == 1582 && month == 10) return 21;
    int days[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (month == 2) {
        return IsLeapYear(year) ? 29 : 28;
    }
    return days[month];
}
```
)
=== 日期转换为天数函数
#block(inset: (left: 1.0em))[
累计公元1年1月1日到输入日期的天数
]
#zebraw(
highlight-lines: (
  ..range(12,14),(13,[补上10天空缺]),
),
```cpp
int Date::DateToNum(const Date &d) {
    int num = 0;
    // 计算完整年的天数
    for (int y = 1; y < d.year; y++) {
        num += GetYearDays(y);         
    }
    // 计算完整月的天数
    for (int m = 1; m < d.month; m++) {
        num += GetMonthDays(d.year, m);
    }
    // 处理当前月份中的日期
    if (d.year == 1582 && d.month == 10 && d.day >= 15) {
        num += d.day - 10;  
    } else {
        num += d.day;
    }
    return num;
}
```
)

=== 天数转星期函数
(天数+5) % 7 = n，n=0表示星期日，n=1表示星期一，以此类推
#zebraw(
```cpp
int Date::Week(const Date &d) {
    return (DateToNum(d) + 5) % 7;
}
```
)

=== 天数转换为日期函数
#zebraw(
highlight-lines: (
  ..range(2,8),(8,[通过循环逐年减去每年的天数，直到剩余天数不足以构成完整的一年]),
  ..range(10,16),(16,[同样的方式逐月减去每月的天数，直到剩余天数不足以构成完整的一月]),
  ..range(18,21),(21,[处理1582年10月的特殊情况,有效日序号映射回实际日期])
),
```cpp
Date Date::NumToDate(int n) {
    int year = 1;
    while (true) {
        int yearDays = GetYearDays(year);
        if (n <= yearDays) break;
        n -= yearDays;
        year++;
    }
   
    int month = 1;
    while (true) {
        int monthDays = GetMonthDays(year,month);
        if (n <= monthDays) break;
        n -= monthDays;
        month++;
    }


    if (year == 1582 && month == 10 && n > 4) {
        n += 10;
    }

    return Date(year, month, n);
}
```
)


=== 重载函数
#let code = ```cpp
Date Date::operator+(int days) const {
    int total = DateToNum(*this) + days;
    return NumToDate(total);
}

Date Date::operator-(int days) const {
    int total = DateToNum(*this) - days;
    return NumToDate(total);
}
bool Date::operator<(const Date &other) const { 
    if (year != other.year) return year < other.year;
    if (month != other.month) return month < other.month;
    return day < other.day;
}

bool Date::operator<=(const Date &other) const { 
    return !(other < *this);
}

bool Date::operator>(const Date &other) const { 
    return other < *this;
}
```
- 重载加减运算符
#zebraw(
    line-range:(1,10),
    code,
    highlight-lines: (
        ..range(1,4),(4,[重载加法运算，先转成天数，天数+days，再转回日期]),
        ..range(6,9),(9,[重载减法运算，先转成天数，天数-days，再转回日期])
    )
)
#pagebreak()
- 重载比较运算符
#zebraw(
    line-range:(10,23),
    code,
    highlight-lines: (
        ..range(10,14),(14,[重载比较运算，先判断年份，再判断月份，再判断日期 a < b]),
        ..range(16,18),(18,[重载比较运算，b < a 的逆是 a <= b]),
        ..range(20,22),(22,[重载比较运算，b < a 等价于 a > b])
    )
)

=== 打印函数

#let code = ```cpp
void PrintCalendar(int year) {
    const char *weekdays[] = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
    const char *months[] = {"一月", "二月", "三月", "四月", "五月", "六月", 
                           "七月", "八月", "九月", "十月", "十一月", "十二月"};
    
    cout << endl << setw(28) << year << "年" << endl;
    cout << "---------------------------------------------------" << endl;
    
    for (int month = 1; month <= 12; month++) {
        cout << right << endl << setw(28) << months[month - 1] << endl;
        cout << " ";
        for (int i = 0; i < 7; i++) {
            cout << weekdays[i] << "  ";
        }
        cout << endl;

        Date firstDay(year, month, 1);
        int startWeek = Date::Week(firstDay);
        int monthDays = Date::GetMonthDays(year,month);

        for (int i = 0; i < startWeek; i++) {
            cout << "        ";
        }
        for (int day = 1; day <= monthDays; day++) {
            int displayDay = day;
            if (year == 1582 && month == 10 && day > 4) { 
                displayDay = day + 10;
            }
            if (displayDay < 10) {
                cout << "   " << displayDay << "    ";
            } else {
                cout << "  " << displayDay << "    ";
            }
            if ((startWeek + day) % 7 == 0) {
                cout << endl;
            }
        }
        cout << endl;
        cout << "---------------------------------------------------" << endl;
    }
}
```
- 打印表头
#zebraw(line-range: (1, 16),
code,highlight-lines: (
    (9,[循环打印12个月]),
    ..range(10,15),(15,[打印每个月的表头]),
    ..range(6,7),(7,[居中打印年份]),
))

- 获取每个月1号是星期几，以及该月的天数
#zebraw(line-range:(17,20),code)
#pagebreak()
- 打印每个月的日历
#zebraw(line-range:(21,42),
code,highlight-lines:(
    ..range(21,23),(23,[控制1号的位置落在对应星期下面]),
    (24,[循环输出该月所有日子]),
    ..range(26,28),(28,[跳过显示1582年10月5日至14日]),
    ..range(29,33),(33,[控制格式使每个数字保持在对应星期正下方]),
    ..range(34,36),(36,[每当输出到星期六时换行]),

))

=== 主函数

#let code =```cpp
int main() {
    system("chcp 65001");

    const string weekdays[] = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};

    while (true) {
        cout << "\n========== 日历功能菜单 ==========" << endl;
        cout << "1. 打印年历" << endl;
        cout << "2. 查询某天是星期几" << endl;
        cout << "3. 计算 N 天后的日期" << endl;
        cout << "4. 计算 N 天前的日期" << endl;
        cout << "5. 计算两个日期相差天数" << endl;
        cout << "0. 退出" << endl;
        cout << "请选择: ";

        int choice;
        cin >> choice;

        if (choice == 0) break;
        int y, m, d, n;
        switch (choice) {
        case 1: {
            cout << "输入年份: ";
            cin >> y;
            PrintCalendar(y);
            system("pause");
            break;
        }
        case 2: {
            cout << "输入日期(年 月 日): ";
            cin >> y >> m >> d;
            Date date(y, m, d);
            cout << y << "-" << m << "-" << d << " 是 "
                 << weekdays[Date::Week(date)] << endl;
            system("pause");
            break;
        }
        case 3: {
            cout << "输入日期(年 月 日): ";
            cin >> y >> m >> d;
            cout << "输入天数: ";
            cin >> n;
            Date date(y, m, d);
            Date result = date + n;    
            cout << y << "-" << m << "-" << d << " + " << n << " 天 = "
                 << result.GetYear() << "-" << result.GetMonth() << "-" << result.GetDay() << endl;
            system("pause");
            break;
        }
        case 4: {
            cout << "输入日期(年 月 日): ";
            cin >> y >> m >> d;
            cout << "输入天数: ";
            cin >> n;
            Date date(y, m, d);
            Date result = date - n;    
            cout << y << "-" << m << "-" << d << " - " << n << " 天 = "
                 << result.GetYear() << "-" << result.GetMonth() << "-" << result.GetDay() << endl;
            system("pause");
            break;
        }
        case 5: {
            cout << "输入第一个日期(年 月 日): ";
            cin >> y >> m >> d;
            Date d1(y, m, d);
            cout << "输入第二个日期(年 月 日): ";
            cin >> y >> m >> d;
            Date d2(y, m, d);

            if (d2 < d1) swap(d1, d2);

            int diff = Date::DateToNum(d2) - Date::DateToNum(d1);
            cout << "相差 " << diff << " 天" << endl;
            system("pause");
            break;
        }
        default:
            cout << "无效选择，请重试" << endl;
            system("pause");
        }
    }

    return 0;
}
```
- 显示菜单，用户输入选项
#zebraw(line-range:(1,18),code)
#pagebreak()
- 输入0退出程序，输入1进入万年历程序
#zebraw(line-range:(19,29),code)
- 输入2查询某天是星期几
#zebraw(line-range: (29,38),code)
- 输入3计算 N 天后的日期，输入4计算 N 天前的日期
#zebraw(line-range: (38,62),code)
#pagebreak()
- 输入5计算两个日期相差天数
#zebraw(line-range: (62,77),code)
- 其他选项错误提示
#zebraw(line-range:(77,82),code)
= 测试与结论
== 测试
=== 打印2026年日历
#align(center)[
#grid(
  columns: 2,
  gutter :1em,
  [#image("image/1-4.png",width: 90%)],[#image("image/5-10.png",width: 80%)],
  [#image("image/11-12.png",width: 100%)]
)
]
=== 查询2026年5月20日是星期几
#align(center)[#image("image/week.png",width: 50%)]
#v(1cm)
=== 日期加减法
#grid(
  columns: 2,
  gutter :1em,
  [#image("image/plus.png",width: 95%)],[#image("image/minus.png",width: 100%)]
)
#v(1cm)
=== 计算两个日期相差天数
#align(center)[#image("image/duration.png",width: 50%)]
== 结论
本程序可以很精确地输出任意年份的日历，且输出的日历与真实日历完全一致，同时本程序还扩展了查询星期，计算天数差等功能。
= 课程设计与总结
通过本次课程设计，我实现了一个功能完善的日历程序，能够打印任意年份的日历，并提供日期查询和计算功能。在实现过程中，我深入理解了日期和时间的处理方法，特别是处理历史上的特殊日期和闰年规则。通过重载运算符，我使得日期的加减和比较操作更加直观和方便。总的来说，这次课程设计不仅让我巩固了C++编程技能，还让我对日期处理有了更深入的理解。