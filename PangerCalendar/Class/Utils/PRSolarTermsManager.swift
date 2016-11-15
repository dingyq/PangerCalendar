//
//  PRSolarTermsManager.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/11/4.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation

let JD2000:Double = 2000
let MATH_PI:Double = 3.1415926
let RADIAN_PER_ANGLE:Double = 180/MATH_PI

let nutation:[Dictionary<String, Double>] = []

typealias VSOP87_COEFFICIENT = Dictionary<String, Double>

let Earth_L0:[VSOP87_COEFFICIENT] = []
let Earth_L1:[VSOP87_COEFFICIENT] = []
let Earth_L2:[VSOP87_COEFFICIENT] = []
let Earth_L3:[VSOP87_COEFFICIENT] = []
let Earth_L4:[VSOP87_COEFFICIENT] = []
let Earth_L5:[VSOP87_COEFFICIENT] = []

let Earth_R0:[VSOP87_COEFFICIENT] = []
let Earth_R1:[VSOP87_COEFFICIENT] = []
let Earth_R2:[VSOP87_COEFFICIENT] = []
let Earth_R3:[VSOP87_COEFFICIENT] = []
let Earth_R4:[VSOP87_COEFFICIENT] = []

let Earth_B0:[VSOP87_COEFFICIENT] = []
let Earth_B1:[VSOP87_COEFFICIENT] = []
let Earth_B2:[VSOP87_COEFFICIENT] = []
let Earth_B3:[VSOP87_COEFFICIENT] = []
let Earth_B4:[VSOP87_COEFFICIENT] = []


class PRSolarTermsManager: NSObject {
    
    override init() {
        super.init()
    }
    
    static let manager: PRSolarTermsManager = PRSolarTermsManager()
    
    func mod360Degree(degree: Double) -> Double {
        let i:Int = Int(degree)
        let f:Double = degree - Double(i)
        return Double(Double(i%360) + f)+360
    }
    
    // 对一个周期项系数表进行求和计算
    func calcPeriodicTerm(coff: [VSOP87_COEFFICIENT], count: Int, dt: Double) -> Double {
        var val:Double = 0.0
        for index in 0...count {
            val = val + coff[index]["A"]! * cos((coff[index]["B"]! + coff[index]["C"]! * dt))
        }
        
        return val
    }
    
    /*
     * 使用VSOP87行星理论计算行星日心黄经的代码实现，首先根据VSOP87D表的数据计算出L0-L5，
     * 计算出地球的日心黄经，计算出来的单位是弧度，因此转换成度分秒单位，最后使用将结果转换成太阳的地心黄经
     */
    func calcSunEclipticLongitudeEC(dt:Double) -> Double {
        let L0:Double = self.calcPeriodicTerm(coff: Earth_L0, count: Earth_L0.count, dt: dt)
        let L1:Double = self.calcPeriodicTerm(coff: Earth_L1, count: Earth_L1.count, dt: dt);
        let L2:Double = self.calcPeriodicTerm(coff: Earth_L2, count: Earth_L2.count, dt: dt);
        let L3:Double = self.calcPeriodicTerm(coff: Earth_L3, count: Earth_L3.count, dt: dt);
        let L4:Double = self.calcPeriodicTerm(coff: Earth_L4, count: Earth_L4.count, dt: dt);
        let L5:Double = self.calcPeriodicTerm(coff: Earth_L5, count: Earth_L5.count, dt: dt);
        
        let L:Double = (((((L5 * dt + L4) * dt + L3) * dt + L2) * dt + L1) * dt + L0) / 100000000.0;
        
        /*地心黄经 = 日心黄经 + 180度*/
        return (self.mod360Degree(degree: self.mod360Degree(degree:L / RADIAN_PER_ANGLE) + 180.0));
    }
    
    // 计算太阳的地心黄纬
    func calcSunEclipticLatitudeEC(dt: Double) -> Double {
        let B0:Double = self.calcPeriodicTerm(coff: Earth_B0, count: Earth_B0.count, dt: dt);
        let B1:Double = self.calcPeriodicTerm(coff: Earth_B1, count: Earth_B1.count, dt: dt);
        let B2:Double = self.calcPeriodicTerm(coff: Earth_B2, count: Earth_B2.count, dt: dt);
        let B3:Double = self.calcPeriodicTerm(coff: Earth_B3, count: Earth_B3.count, dt: dt);
        let B4:Double = self.calcPeriodicTerm(coff: Earth_B4, count: Earth_B4.count, dt: dt);
        
        let B:Double = (((((B4 * dt) + B3) * dt + B2) * dt + B1) * dt + B0) / 100000000.0;
        /*地心黄纬 = －日心黄纬*/
        return -(B / RADIAN_PER_ANGLE)
    }
    
    /*
     * 计算黄经的修正量，longitude和latitude参数是由VSOP87理论计算出的太阳地心黄经和地心黄纬，
     * 单位是度，dt是儒略千年数，返回值单位是度
     */
    func adjustSunEclipticLongitudeEC(dt: Double, longitude: Double, latitude: Double) -> Double {
        // T是儒略世纪数
        let T:Double = dt * 10
        var dbLdash = longitude - 1.397 * T - 0.00031 * T * T
        
        // 转换为弧度
        dbLdash *= RADIAN_PER_ANGLE;
        return (-0.09033 + 0.03916 * (cos(dbLdash) + sin(dbLdash)) * tan(latitude * RADIAN_PER_ANGLE)) / 3600.0;
    }
    
    // 计算5个基本角距
    func getEarthNutationParameter(dt: Double) -> [Double] {
        /*T是从J2000起算的儒略世纪数*/
        let T:Double = dt * 10
        let T2:Double = T * T
        let T3:Double = T2 * T
        
        /*平距角（如月对地心的角距离）*/
        let D:Double = 297.85036 + 445267.111480 * T - 0.0019142 * T2 + T3 / 189474.0;
        
        /*太阳（地球）平近点角*/
        let M:Double = 357.52772 + 35999.050340 * T - 0.0001603 * T2 - T3 / 300000.0;
        
        /*月亮平近点角*/
        let Mp:Double = 134.96298 + 477198.867398 * T + 0.0086972 * T2 + T3 / 56250.0;
        
        /*月亮纬度参数*/
        let F:Double = 93.27191 + 483202.017538 * T - 0.0036825 * T2 + T3 / 327270.0;
        
        /*黄道与月亮平轨道升交点黄经*/
        let Omega:Double = 125.04452 - 1934.136261 * T + 0.0020708 * T2 + T3 / 450000.0;
        
        return [D, M, Mp, F, Omega]
    }
    
    // 计算黄经章动
    func calcEarthLongitudeNutation(dt: Double) -> Double {
        let T:Double = dt * 10
        let paramArr = self.getEarthNutationParameter(dt: dt)
        
        let D:Double = paramArr[0]
        let M:Double = paramArr[1]
        let Mp:Double = paramArr[2]
        let F:Double = paramArr[3]
        let Omega:Double = paramArr[4]
        
        //        let nutation: Array<Dictionary<String, Double>> = []
        var resulte:Double = 0.0
        for i in 0 ..< nutation.count {
            let sita: Double = nutation[i]["D"]! * D + nutation[i]["M"]! * M + nutation[i]["Mp"]! * Mp + nutation[i]["F"]! * F + nutation[i]["omega"]! * Omega
            resulte += (nutation[i]["sine1"]! + nutation[i]["sine2"]! * T ) * sin(sita)
        }
        /*先乘以章动表的系数 0.0001，然后换算成度的单位*/
        return resulte * 0.0001 / 3600.0;
    }
    
    // 计算交角章动
    func calcEarthObliquityNutation(dt: Double) -> Double {
        let T:Double = dt * 10; /*T是从J2000起算的儒略世纪数*/
        let paramArr = self.getEarthNutationParameter(dt: dt)
        
        let D:Double = paramArr[0]
        let M:Double = paramArr[1]
        let Mp:Double = paramArr[2]
        let F:Double = paramArr[3]
        let Omega:Double = paramArr[4]
        
        var resulte:Double = 0.0 ;
        for i in 0 ..< nutation.count {
            let sita:Double = nutation[i]["D"]! * D + nutation[i]["M"]! * M + nutation[i]["Mp"]! * Mp + nutation[i]["F"]! * F + nutation[i]["omega"]! * Omega
            
            resulte += (nutation[i]["cosine1"]! + nutation[i]["cosine2"]! * T ) * cos(sita);
        }
        /*先乘以章动表的系数 0.001，然后换算成度的单位*/
        return resulte * 0.0001 / 3600.0;
    }
    
    // 太阳到地球的距离可以这样算出来
    func calcSunEarthRadius(dt: Double) -> Double {
        let R0:Double = self.calcPeriodicTerm(coff: Earth_R0, count: Earth_R0.count, dt: dt);
        let R1:Double = self.calcPeriodicTerm(coff: Earth_R1, count: Earth_R1.count, dt: dt);
        let R2:Double = self.calcPeriodicTerm(coff: Earth_R2, count: Earth_R2.count, dt: dt);
        let R3:Double = self.calcPeriodicTerm(coff: Earth_R3, count: Earth_R3.count, dt: dt);
        let R4:Double = self.calcPeriodicTerm(coff: Earth_R4, count: Earth_R4.count, dt: dt);
        
        let R:Double = (((((R4 * dt) + R3) * dt + R2) * dt + R1) * dt + R0) / 100000000.0;
        return R;
    }
    
    // 由VSOP87理论计算出来的几何位置黄经，经过坐标转换，章动修正和光行差修正后，就可以得到比较准确的太阳地心视黄经
    // 参数jde是力学时时间，单位是儒略日，返回太阳地心视黄经，单位是度。
    func getSunEclipticLongitudeEC(jde: Double) -> Double {
        let dt: Double = (jde - JD2000) / 365250.0; /*儒略千年数*/
        
        // 计算太阳的地心黄经
        var longitude:Double = self.calcSunEclipticLongitudeEC(dt: dt);
        
        // 计算太阳的地心黄纬
        let latitude:Double = self.calcSunEclipticLatitudeEC(dt: dt) * 3600.0;
        
        // 修正精度
        longitude += self.adjustSunEclipticLongitudeEC(dt: dt, longitude: longitude, latitude: latitude);
        
        // 修正天体章动
        longitude += self.calcEarthLongitudeNutation(dt: dt);
        
        // 修正光行差
        /*太阳地心黄经光行差修正项是: -20".4898/R*/
        longitude -= (20.4898 / self.calcSunEarthRadius(dt:dt)) / (20 * MATH_PI);
        
        return longitude;
    }
    
    // TODO: wait to complete
    func estimateSTtimeScope(year: Int, angle: Int, lJD:Double, rJD:Double) {
        
    }
    
    // TODO: wait to complete
    func getSunEclipticLongitudeECDegree(solarTermsJD: Double) -> Double {
        
        return 0.0
    }
    
    // TODO: wait to complete
    func getInitialEstimateSolarTerms(year: Int, angle: Int) -> Double {
        
        return 0.0
    }
    
    func calculateSolarTerms(year: Int, angle: Int) -> Double {
        var lJD:Double = 0.0
        var rJD:Double = 0.0
        self.estimateSTtimeScope(year: year, angle: angle, lJD: lJD, rJD: rJD); /*估算迭代起始时间区间*/
        
        var solarTermsJD:Double = 0.0;
        var longitude:Double = 0.0;
        repeat {
            solarTermsJD = ((rJD - lJD) * 0.618) + lJD;
            longitude = self.getSunEclipticLongitudeECDegree(solarTermsJD: solarTermsJD);
            /*
             * 对黄经0度迭代逼近时，由于角度360度圆周性，估算黄经值可能在(345,360]和[0,15)两个区间，
             * 如果值落入前一个区间，需要进行修正
             */
            longitude = ((angle == 0) && (longitude > 345.0)) ? longitude - 360.0 : longitude;
            (longitude > Double(angle)) ? (rJD = solarTermsJD) : (lJD = solarTermsJD);
        } while((rJD - lJD) > 0.0000001)
        
        return solarTermsJD;
        
    }
    
    
    func calculateSolarTermsNewton(year: Int, angle: Int) -> Double {
        var JD0:Double = 0.0
        var JD1:Double = 0.0
        var stDegree:Double = 0.0
        var stDegreep:Double = 0.0
        JD1 = self.getInitialEstimateSolarTerms(year:year, angle:angle)
        repeat {
            JD0 = JD1;
            stDegree = self.getSunEclipticLongitudeECDegree(solarTermsJD: JD0) - Double(angle);
            stDegreep = (self.getSunEclipticLongitudeECDegree(solarTermsJD: JD0 + 0.000005) - self.getSunEclipticLongitudeECDegree(solarTermsJD: JD0 - 0.000005)) / 0.00001
            JD1 = JD0 - stDegree / stDegreep;
        } while((fabs(JD1 - JD0) > 0.0000001));
        
        return JD1;
    }
    
}










