//
//  PRTheme.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private let s_Instance: PRTheme = PRTheme()

class PRTheme: NSObject {
    // MARK: Font
    var smallFont: UIFont = UIFont.systemFont(ofSize: 11)
    var defaultFont: UIFont = UIFont.systemFont(ofSize: 13)
    var font14: UIFont = UIFont.systemFont(ofSize: 14)
    var bigFont: UIFont = UIFont.systemFont(ofSize: 15)
    var font17: UIFont = UIFont.systemFont(ofSize: 17)
    
    // MARK: color
    var redCustomColor: UIColor = RGBCOLOR(r: 187, 36, 13)
    var redCustomLightColor: UIColor = RGBACOLOR(r: 187, 36, 13, 0.25)
    
    var greenCustomColor: UIColor = RGBCOLOR(r: 37, 192, 28)
    var greenCustomLightColor: UIColor = RGBACOLOR(r: 37, 192, 28, 0.25)
    
    var blackCustomColor: UIColor = RGBCOLOR(r: 51, 51, 51)
    var blackCustomLightColor: UIColor = RGBACOLOR(r: 51, 51, 51, 0.25)
 
    var blueCustomColor: UIColor = RGBCOLOR(r: 77, 177, 218)
    var blueCustomLightColor: UIColor = RGBACOLOR(r: 77, 177, 218, 0.25)
    
    var grayColor220 = RGBCOLOR(r: 220, 220, 220)
    var grayColor247 = RGBCOLOR(r: 247, 247, 247)
    
    var bgColor = RGBCOLOR(r: 255, 255, 255)
    
    var weekendTipColor: UIColor!
    var weekendInMonthColor: UIColor!
    var weekendOutMonthColor: UIColor!
    
    var weekdayTipColor: UIColor!
    var weekdayInMonthColor: UIColor!
    var weekdayOutMonthColor: UIColor!
    
    var sosolarTermInMonthColor: UIColor!
    var sosolarTermOutMonthColor: UIColor!
    var festivalInMonthColor: UIColor!
    var festivalOutMonthColor: UIColor!
    
    var borderLineColor: UIColor!
    
    
    class func current() -> PRTheme {
        return s_Instance
    }
    
    override init() {
        super.init()
        weekendTipColor = redCustomColor
        weekendInMonthColor = redCustomColor
        weekendOutMonthColor = redCustomLightColor
        
        weekdayTipColor = blackCustomColor
        weekdayInMonthColor = blackCustomColor
        weekdayOutMonthColor = blackCustomLightColor
        
        sosolarTermInMonthColor = redCustomColor
        sosolarTermOutMonthColor = redCustomLightColor
        
        festivalInMonthColor = blueCustomColor
        festivalOutMonthColor = blueCustomLightColor
        
        borderLineColor = grayColor220
    }
    
    func image(name: String?) -> UIImage? {
        var image: UIImage?
        if name != nil {
            image = UIImage(named: name!)
        }
        return image
    }
    
}

func PRCurrentTheme() -> PRTheme {
    return PRTheme.current()
}

func PRThemedImage(name: String?) -> UIImage? {
    return PRTheme.current().image(name: name)
}
