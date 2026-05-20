#include <iostream>
#include <iomanip>
using namespace std;


// 日期类
class Date {
private:
    int year;
    int month;
    int day;

public:
    Date(int y = 1, int m = 1, int d = 1){
        if(y==1582 && m==10 && d>=5 && d<=14){ // 1582年10月5-14日不存在，直接跳到10月15日
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
    static Date NumToDate(int n);
    static int Week(const Date &d);
    
    Date operator+(int days) const;
    Date operator-(int days) const;
    int operator-(const Date &other) const;
    bool operator<(const Date &other) const;
    bool operator<=(const Date &other) const;
    bool operator>(const Date &other) const;

    
};

// 平润年判断函数
bool IsLeapYear(int y) {
    if (y > 1582)
        return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
    else
        return y % 4 == 0;
}


// 获取具体年份天数函数
int GetYearDays(int y) {
    if (y == 1582) return 355;
    return IsLeapYear(y) ? 366 : 365;
}

// 获取具体月份天数函数
int Date::GetMonthDays(int year,int month) {
    if (year == 1582 && month == 10) return 21;
    int days[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (month == 2) {
        return IsLeapYear(year) ? 29 : 28;
    }
    return days[month];
}

// 日期转换为天数函数
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
        num += d.day - 10;  // 跳过被删除的10天
    } else {
        num += d.day;
    }
    return num;
}

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
    // 处理1582年10月的日期映射（跳过了5-14日）
    if (year == 1582 && month == 10 && n > 4) {
        n += 10;  // 有效日序号映射回实际日期
    }
    return Date(year, month, n);
}

int Date::Week(const Date &d) {
    
    return (DateToNum(d) + 5) % 7;
}

Date Date::operator+(int days) const {
    int total = DateToNum(*this) + days;
    return NumToDate(total);
}

Date Date::operator-(int days) const {
    int total = DateToNum(*this) - days;
    return NumToDate(total);
}

int Date::operator-(const Date &other) const {
    int num1=DateToNum(*this);
    int num2=DateToNum(other);
    if(num2 > num1) swap(num1,num2);
    return num1-num2;
}
bool Date::operator<(const Date &other) const { // a < b
    if (year != other.year) return year < other.year;
    if (month != other.month) return month < other.month;
    return day < other.day;
}

bool Date::operator<=(const Date &other) const { // b < a 的逆是 a <= b
    return !(other < *this);
}

bool Date::operator>(const Date &other) const { // b < a 等价于 a > b 
    return other < *this;
}

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
            if (year == 1582 && month == 10 && day > 4) { // 格里高利历1582年10月4日开始跳过10天
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

        switch (choice) {
        case 1: {
            int y;
            cout << "输入年份: ";
            cin >> y;
            PrintCalendar(y);
            system("pause");
            break;
        }
        case 2: {
            int y, m, d;
            cout << "输入日期(年 月 日): ";
            cin >> y >> m >> d;
            Date date(y, m, d);
            cout << y << "-" << m << "-" << d << " 是 "
                 << weekdays[Date::Week(date)] << endl;
            system("pause");
            break;
        }
        case 3: {
            int y, m, d, n;
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
            int y, m, d, n;
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
            int y, m, d;
            cout << "输入第一个日期(年 月 日): ";
            cin >> y >> m >> d;
            Date d1(y, m, d);
            cout << "输入第二个日期(年 月 日): ";
            cin >> y >> m >> d;
            Date d2(y, m, d);
            int diff = d1 - d2;
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
