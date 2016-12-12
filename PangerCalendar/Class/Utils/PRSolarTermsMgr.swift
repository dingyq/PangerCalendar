//
//  PRSolarTermsMgr.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/12.
//  Copyright © 2016年 panger. All rights reserved.
//


// 经过简单测试，数据正确，当前采用的24节气算法

import Foundation

private struct PRSolarTerm {
    var solarIndex: Int
    var solarDate: Int
    
    init(_solarIndex: Int, _solarDate: Int) {
        self.solarIndex = _solarIndex
        self.solarDate = _solarDate
    }
}

private let s_Instance: PRSolarTermsMgr = PRSolarTermsMgr()

class PRSolarTermsMgr: NSObject {
    
    class func shareMgr() -> PRSolarTermsMgr {
        return s_Instance
    }
    
    func solartermIndex(year: Int, month: Int, day: Int) -> Int {
        let ranges: [Int] = [0xa3, 0x292, 0xe4, 0x2d3, 0xc4, 0x2b3, 0xe4, 0x2d4, 0xe4, 0x2d4, 0x106, 0x316,
                             0x126, 0x316, 0x126, 0x316, 0x127, 0x316, 0x106, 0x2f5, 0x106, 0x2f5, 0xe4, 0x2b3]
        
        var index: Int = -1;
        let guess: Int = month == 1 ? 22 : (month - 2) * 2;
        
        if self.solartermRangeContains(range: ranges[guess], day: day) || self.solartermRangeContains(range: ranges[guess + 1], day: day) {
            var solarTerms: [PRSolarTerm] = Array(repeatElement(PRSolarTerm(_solarIndex: 0, _solarDate: 0), count: 2))
            for n in month * 2 - 1...month * 2 {
                let termdays: Double = self.term(y: year, n: n, pd: 1)
                let mdays: Double = self.antiDayDifference(y: year, x: floor(termdays))
                
                let tMonth: Int = Int(ceil(Double(n) / 2))
                let tday: Int = Int(mdays) % 100
                
                if n >= 3 {
                    solarTerms[n - month * 2 + 1].solarIndex = n - 3
                } else {
                    solarTerms[n - month * 2 + 1].solarIndex = n + 21
                }
                solarTerms[n - month * 2 + 1].solarDate = self.compressDate(year: year, month: tMonth, day: tday)
            }
            for i in 0...1 {
                if solarTerms[i].solarDate == self.compressDate(year: year, month: month, day: day) {
                    index = solarTerms[i].solarIndex
                    break
                }
            }
        }
        
        return index
    }
    
    func solartermName(index: Int) -> String {
        if index >= 0 && index < 24 {
            let solarTerms: [String] = ["立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"]
            return solarTerms[index]
        } else {
            return ""
        }
    }
    
    private func compressDate(year: Int, month: Int, day: Int) -> Int {
        return (year << 7) | (month << 5) | day
    }
    
    private func solartermRangeContains(range: Int, day: Int) -> Bool {
        return (day >= (range & 0x1F) && day <= (range >> 5))
    }
    
    private func ifGregorian(y: Int, m: Int, d: Int, opt: Int) -> Int {
        if opt == 1 {
            if y > 1582 || (y == 1582 && m > 10) || (y == 1582 && m == 10 && d > 14) {
                return 1        //Gregorian
            } else {
                if y == 1582 && m == 10 && d >= 5 && d <= 14 {
                    return -1   //空
                } else {
                    return 0    //Julian
                }
            }
        }
        
        if opt == 2 {
            return 1            //Gregorian
        }
        if opt == 3 {
            return 0            //Julian
        }
        
        return -1
    }
    
    private func dayDifference(y: Int, m: Int, d: Int) -> Int {
        let ifG: Int = self.ifGregorian(y: y, m: m, d: d, opt: 1)
        var monL: [Int] = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if (ifG == 1) {
            if ((y % 100 != 0 && y % 4 == 0) || (y % 400 == 0)) {
                monL[2] += 1;
            } else {
                if (y % 4 == 0) {
                    monL[2] += 1;
                }
            }
        }
        
        var v: Int = 0
        for i in 0...m - 1 {
            v += monL[i];
        }
        v += d;
        if y == 1582 {
            if ifG == 1 {
                v -= 10
            }
            if ifG == -1 {
                v = 0
            }
        }
        return v
    }
    
    private func equivalentStandardDay(y: Int, m: Int, d: Int) -> Double {
        //Julian的等效标准天数
        let yD = Double(y)
        
        var v: Double = (yD - 1) * 365 + floor((yD - 1) / 4)
        v = v + Double(self.dayDifference(y: y, m: m, d: d)) - 2
        
        if y > 1582 {
            //Gregorian的等效标准天数
            v += -floor(Double((y - 1) / 100)) + floor(Double((y - 1) / 400)) + 2
        }
        return v;
    }
    
    private func term(y: Int, n: Int, pd: Int) -> Double {
        let yD = Double(y)
        let nD = Double(n)
        //儒略日
        let juD: Double = yD * (365.2423112 - 6.4e-14 * (yD - 100) * (yD - 100) - 3.047e-8 * (yD - 100)) + 15.218427 * nD + 1721050.71301
        
        //角度
        let tht: Double = 3e-4 * yD - 0.372781384 - 0.2617913325 * nD
        
        //年差实均数
        let yrD: Double = (1.945 * sin(tht) - 0.01206 * sin(2 * tht)) * (1.048994 - 2.583e-5 * yD)
        
        //朔差实均数
        let shuoD: Double = -18e-4 * sin(2.313908653 * yD - 0.439822951 - 3.0443 * nD)
        
        return (pd != 0) ? (juD + yrD + shuoD - self.equivalentStandardDay(y: y, m: 1, d: 0) - 1721425) : (juD - self.equivalentStandardDay(y: y, m: 1, d: 0) - 1721425)
    }
    
    private func antiDayDifference(y: Int, x: Double) -> Double {
        var m: Int = 1
        var xD: Double = x
        for j in 1...12 {
            let mL: Int = self.dayDifference(y: y, m: j + 1, d: 1) - self.dayDifference(y: y, m: j, d: 1)
            if Int(xD) <= mL || j == 12 {
                m = j
                break
            } else {
                xD -= Double(mL)
            }
        }
        return 100 * Double(m) + xD
    }
}
