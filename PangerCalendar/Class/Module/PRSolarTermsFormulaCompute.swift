//
//  PRSolarTermsFormulaCompute.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/7.
//  Copyright © 2016年 panger. All rights reserved.
//

// 简单公式计算，准确度有限，暂未使用

import Foundation

private enum PRSolarTerms : Int {
    case SpringBegins = 0           // 立春
    case RainWater = 1              // 雨水
    case InsectsAwaken = 2          // 惊蛰
    case SpringEquinox = 3          // 春分
    case PureBrightness = 4         // 清明
    case GrainRain = 5              // 谷雨
    
    case SummerBegins = 6           // 立夏
    case GrainFull = 7              // 小满
    case GrainInEar = 8             // 芒种
    case SummerSolstice = 9         // 夏至
    case SlightHeat = 10            // 小暑
    case GreatHeat = 11             // 大暑
    
    case AutumnBegins = 12          // 立秋
    case LimitOfHeat = 13           // 处暑
    case WhiteDew = 14              // 白露
    case AutumnalEquinox = 15       // 秋分
    case ColdDew = 16               // 寒露
    case FrostDescends = 17         // 霜降
    
    case WinterBegins = 18          // 立冬
    case SlightSnow = 19            // 小雪
    case GreatSnow = 20             // 大雪
    case WinterSolstice = 21        // 冬至
    case SlightCold = 22            // 小寒
    case GreatCold = 23             // 大寒
}

private let s_SolarTermDValue : Double = 0.2422

private let s_SolarTermCValues20 : [Double] = [4.15, 18.73, 5.63, 20.646, 5.59, 20.888,
                                     6.318, 21.86, 6.5, 22.20, 7.928, 23.65,
                                     8.35, 23.95, 8.44, 23.822, 9.098, 24.218,
                                     8.218, 23.08, 7.9, 22.60, 6.11, 20.84]

private let s_SolarTermCValues21 : [Double] = [3.87, 18.73, 5.63, 20.646, 4.81, 20.1,
                                     5.52, 21.04, 5.678, 21.37, 7.108, 22.83,
                                     7.5, 23.13, 7.646, 23.042, 8.318, 23.438,
                                     7.438, 22.36, 7.18, 21.94, 5.4055, 20.12]

private let kSolarTermIndex : String = "kSolarTermIndex"
let kSolarTermMonth: String = "kSolarTermMonth"
let kSolarTermDay: String = "kSolarTermDay"


private let s_Instance: PRSolarTermsFormulaCompute = PRSolarTermsFormulaCompute()

class PRSolarTermsFormulaCompute : NSObject {
    
//    计算公式：[Y*D+C]-L
    
    class func shareMgr() -> PRSolarTermsFormulaCompute {
        return s_Instance;
    }
    
    override init() {
        super.init()
    }
    
    private func decomposeCenturyAndYear(year: Int) -> (century: Int, yearLeft: Int) {
        if year < 1900 || year > 2100 {
            return (0, 0)
        }
        let century: Int = year / 100
        let yearLeft: Int = year % 100
        return (century, yearLeft)
    }
    
    func calculateSoloarTerms(year: Int) -> Array<Dictionary<String, AnyObject>> {
        var solarTerms = [Dictionary<String, AnyObject>]()
        let result = self.decomposeCenturyAndYear(year: year)
        var solarTermCValues = s_SolarTermCValues20
        if result.century == 20 {
            solarTermCValues = s_SolarTermCValues21
        }
        for index in 0...23 {
            let month = (index/2 + 1) % 12 + 1
            var leapYear = result.yearLeft / 4
            if index < 2 {
                leapYear = (result.yearLeft - 1) / 4
            }
            let day = Int(Double(result.yearLeft) * s_SolarTermDValue + solarTermCValues[index]) - leapYear
//            var tmpDic = Dictionary<String, AnyObject>()
            let tmpDic = [kSolarTermIndex : index as AnyObject,
                      kSolarTermMonth : month as AnyObject,
                      kSolarTermDay : day as AnyObject]
            solarTerms.append(tmpDic)
        }
//        let springBegins = solarTerms[0]
//        print(springBegins[kSolarTermMonth] as Any, springBegins[kSolarTermDay] as Any)
        return solarTerms
    }
    
}
