#include <iostream>
#include <iomanip>
using namespace std;

class Date {
private:
    int year;
    int month;
    int day;
public:
    Date(int y = 1, int m = 1, int d = 1) : year(y), month(m), day(d) {}

    void SetYear(int y) { year = y; }
    void SetMonth(int m) { month = m; }
    void SetDay(int d) { day = d; }

    int GetYear() const { return year; }
    int GetMonth() const { return month; }
    int GetDay() const { return day; }

    Date operator+(int days);
    Date operator-(int days);
    bool operator<(const Date &other) const;
    bool operator<=(const Date &other) const;
    bool operator>(const Date &other) const;

    static bool IsLeapYear(int y, bool gregorian);
    static int GetYearDays(int y, bool gregorian);
    static int GetMonthDays(const Date &d);
    static int DateToNum(const Date &d);
    static Date NumToDate(int n);
    static int Week(const Date &d);

    // 判断日期是否在格里高利历时期（1582-10-15及之后）
    static bool IsGregorian(const Date &d);
};

// 格里高利历改革分界点：1582-10-15（儒略历1582-10-04之后直接跳到格里高利历1582-10-15）
bool Date::IsGregorian(const Date &d) {
    if (d.year > 1582) return true;
    if (d.year < 1582) return false;
    if (d.month > 10) return true;
    if (d.month < 10) return false;
    return d.day >= 15;
}

bool Date::IsLeapYear(int y, bool gregorian) {
    if (gregorian) {
        return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
    } else {
        return y % 4 == 0;
    }
}

int Date::GetYearDays(int y, bool gregorian) {
    if (y == 1582) return 355;
    return IsLeapYear(y, gregorian) ? 366 : 365;
}

int Date::GetMonthDays(const Date &d) {
    if (d.year == 1582 && d.month == 10) return 21;
    int days[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int m = d.month;
    if (m == 2) {
        // 1582年及之前月份使用儒略历，1582年10月之后使用格里高利历
        bool greg = (d.year > 1582) || (d.year == 1582 && d.month > 10);
        return IsLeapYear(d.year, greg) ? 29 : 28;
    }
    return days[m];
}

int Date::DateToNum(const Date &d) {
    int num = 0;
    // 累计完整年份的天数
    for (int y = 1; y < d.year; y++) {
        if (y < 1582) {
            num += GetYearDays(y, false);  // 儒略历
        } else if (y == 1582) {
            num += 355;                    // 1582年删除10天
        } else {
            num += GetYearDays(y, true);   // 格里高利历
        }
    }
    // 累计当前年份中完整月份的天数
    for (int m = 1; m < d.month; m++) {
        Date temp(d.year, m, 1);
        num += GetMonthDays(temp);
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
    // 按年份递减，根据年份选用合适的历法
    while (true) {
        int yearDays;
        if (year < 1582) {
            yearDays = GetYearDays(year, false);
        } else if (year == 1582) {
            yearDays = 355;
        } else {
            yearDays = GetYearDays(year, true);
        }
        if (n <= yearDays) break;
        n -= yearDays;
        year++;
    }
    int month = 1;
    while (true) {
        Date temp(year, month, 1);
        int monthDays = GetMonthDays(temp);
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

Date Date::operator+(int days) {
    int total = DateToNum(*this) + days;
    return NumToDate(total);
}

Date Date::operator-(int days) {
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
        int monthDays = Date::GetMonthDays(firstDay);

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

int main() {
    system("chcp 65001");
    
    int year;
    cout << "输入年份:";
    cin >> year;
    
    PrintCalendar(year);
    
    cout << "请按任意键继续..." << endl;
    system("pause");
    
    return 0;
}