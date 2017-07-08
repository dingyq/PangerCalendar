//
//  PRCalendarMonth.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/18.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
import Foundation


/// 日历顶部标签占顶部总高度的比例           年月标签/顶部
fileprivate let S_HEADLABLEHEIGHTSCALE: CGFloat = 0.7
/// 日历顶部标签字体大小与顶部总高度的比例     年月字体/顶部标签
fileprivate let S_HEADFOUNTSIZESCALE: CGFloat = 0.4
/// 星期行的高度占顶部总高度的比例           星期行/顶部
fileprivate let S_HEADWEEKDAYHEIGHTSCALE: CGFloat = 0.6
/// 星期行标签字体大小与星期行总高度的比例     星期字体/星期标签
fileprivate let S_HEADWEEKDAYFOUNTSIZESCALE: CGFloat = 0.8
/// 日期按钮标签的字体与日期按钮高度的比例     日期字体/期日按钮
fileprivate let S_CALENDARDAYFOUNTSIZESCALE: CGFloat = 0.4
/// 日期按钮的标记与日期按钮大小的比例         日期标记/期日按钮
fileprivate let S_CALENDARDAYMARKSCALE: CGFloat = 0.3
/// 日期按钮的条标记高度                    日期标记高度
fileprivate let S_CALENDARDAYMARKHEIGHT: CGFloat = 2
/// 日期按钮底部标签的字体与日期按钮高度的比例   日期底部字体/期日按钮
fileprivate let S_CALENDARDAYBUTTOMFOUNTSIZESCALE: CGFloat = 0.2


class PRCalendarMonth: PRBaseView {
    public var datesIndex: Array<Date>!                     // 日期数组
    public var requiredHeight: CGFloat! = 0
    private var calendarLogic: PRCalendarLogic?             // 日历逻辑
    private var buttonsIndex: Array<UIButton>!                   // 按钮数组
    private var markDict: NSMutableDictionary = NSMutableDictionary()        // 标记字典（日期作为索引）
    
    private var numberOfDaysInWeek: Int!                    // 每周几天
    private var numberOfWeeks: Int!                         // 当前月历页面中有几周（行数）
    private var selectedButton: Int!                        // 选中的按钮索引
    private var selectedDate: Date?                         // 选中的日期
    
    private var headerFrame: CGRect!                        // 日历头大小和位置
    private var calendarFrame: CGRect!                      // 日历大小和位置
    private var calendarDayWidth: CGFloat!                  // 日历中天的宽度
    private var calendarDayHeight: CGFloat!                 // 日历中天的高度
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化，frame－大小。aLogic－关联的日历逻辑
    init(frame: CGRect, logic: PRCalendarLogic) {
        super.init(frame: frame)
        // Size is static
        self.numberOfWeeks = 6          //高度（日期个数）
        self.selectedButton = -1        //被选中按钮为－1
        
        // 初始化标记数组
        self.markDict = NSMutableDictionary()
        // 创建一个当前用户的日历对象（NSCalendar用于处理时间相关问题。比如比较时间前后、计算日期所的周别等。）
        let calendar = Calendar.current
        // 创建一个日期组件，并赋予当前日期
        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: Date())
        // 返回components指定的时间
        let todayDate = calendar.date(from: components)!
        // Initialization code
        self.backgroundColor = UIColor.clear            // Red should show up fails.//红色背景，但不显示。
//        self.opaque = true                            //透明
        self.clipsToBounds = true                       //边界裁切
        self.clearsContextBeforeDrawing = false         //不自动清除绘图上下文
        
        // 日历组件的宽度和高度
        //CGFloat headerHeight = frame.size.height/numberOfWeeks;                                   //日历头高度
        let headerHeight: CGFloat = 20.0
        self.headerFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: headerHeight)             //日历头位置和大小
        //日历部分位置和大小
        self.calendarFrame = CGRect(x: 0, y: headerHeight, width: frame.size.width, height: frame.size.height - self.headerFrame.size.height)
        // 创建图像视图，上边栏
        let headerBackground = PRBaseImageView(image: PRThemedImage(name: "CalendarBackground.png"))
        headerBackground.frame = self.headerFrame
        self.addSubview(headerBackground)

        // 创建图像视图，月历内容
        let calendarBackground = PRBaseImageView(image: PRThemedImage(name: "CalendarBackground.png"))
        calendarBackground.frame = self.calendarFrame
        self.addSubview(calendarBackground)
        
        // 创建一个格式化日期类
        let formatter = DateFormatter()
        // 获得星期缩写的数组
        let daySymbols = formatter.shortWeekdaySymbols!
        // 每周几天
        self.numberOfDaysInWeek = daySymbols.count
        
        // 日历中日期的宽度和高度
        self.calendarDayWidth = self.calendarFrame.size.width / CGFloat(self.numberOfDaysInWeek)    //日历中天的宽度
        self.calendarDayHeight = self.calendarFrame.size.height / CGFloat(self.numberOfWeeks)            //日历中天的高度
        // 创建顶部标题，用于显示年份
        var aLabel: UILabel
        // 不要日历头
//        aLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.headerFrame.size.width, height: self.headerFrame.size.height * S_HEADLABLEHEIGHTSCALE))
//        aLabel.backgroundColor = UIColor.clear
//        //aLabel.textAlignment = UITextAlignmentCenter
//        aLabel.textAlignment = NSTextAlignment.center
//        aLabel.font = UIFont.boldSystemFont(ofSize: self.headerFrame.size.height * S_HEADFOUNTSIZESCALE)   //字体大小
//        aLabel.textColor = UIColor.init(patternImage: PRThemedImage(name: "CalendarTitleColor.png")!) //使用图像填充
//        aLabel.shadowColor = UIColor.white      //阴影颜色
//        aLabel.shadowOffset = CGSize(width: 0, height: 1.0)  //阴影偏移
//        formatter.dateFormat = "yyyy年 MM月"      //日期格式
//        aLabel.text = formatter.string(from: logic.referenceDate)   //返回指定格式的日期
//        self.addSubview(aLabel)    //添加到视图
 
        // 分割线视图
//        let lineView = UIView(frame: CGRect(x: 0, y: self.headerFrame.size.height - 1, width: self.headerFrame.size.width, height: 1))
//        lineView.backgroundColor = UIColor.lightGray
//        self.addSubview(lineView)
        
        // Setup weekday names
        // 添加星期名称
        // 获得第一个星期索引
        let firstWeekday = calendar.firstWeekday - 1
        for aWeekday in 0..<self.numberOfDaysInWeek {
            // 符号索引为当前循环次数＋第一个星期索引
            var symbolIndex = aWeekday + firstWeekday
            // 如果符号索引大于星期个数，则循环到队列开始位置
            if (symbolIndex >= self.numberOfDaysInWeek) {
                symbolIndex -= self.numberOfDaysInWeek;
            }
            
            // 获得星期符号，并计算显示位置
            let symbol = daySymbols[symbolIndex]
            let positionX = (CGFloat(aWeekday) * self.calendarDayWidth) - 1
            let weekdayHeight = self.headerFrame.size.height * S_HEADWEEKDAYHEIGHTSCALE; //星期高度行
            let aFrame = CGRect(x: positionX, y: self.headerFrame.size.height - weekdayHeight - 2, width: self.calendarDayWidth, height:weekdayHeight)
            // 创建标签，并添加到视图
            aLabel = UILabel(frame: aFrame)
            aLabel.backgroundColor = UIColor.clear
            aLabel.textAlignment = NSTextAlignment.center
            aLabel.text = symbol
            // 周末高亮
            if (aWeekday == 0 || aWeekday == self.numberOfDaysInWeek-1) {
                aLabel.textColor = PRTheme.current().weekendTipColor
            } else {
                aLabel.textColor = PRTheme.current().weekdayTipColor
            }
            aLabel.font = UIFont.boldSystemFont(ofSize: weekdayHeight * S_HEADWEEKDAYFOUNTSIZESCALE)    //字体大小
            aLabel.shadowColor = UIColor.white
            aLabel.shadowOffset = CGSize(width: 0, height: 1)
            self.addSubview(aLabel)
        }
        
        // Build calendar buttons (6 weeks of 7 days)
        // 建立日历按钮（宽高：6周7天）
        let aDatesIndex = NSMutableArray()
        let aButtonsIndex = NSMutableArray()    //按钮索引
        //每次循环绘制一列
        for aWeek in 0..<self.numberOfWeeks {
            //当前行y坐标
            let positionY = (CGFloat(aWeek) * self.calendarDayHeight) + self.headerFrame.size.height
            self.requiredHeight = positionY + self.calendarDayHeight
            //每次循环绘制一行
            var continueDraw = true
            for aWeekday in 1...self.numberOfDaysInWeek {
                //根据行列获得日期
                let dayDate = PRCalendarLogic.date(weekday: aWeekday, week: aWeek, referenceDate: logic.referenceDate)
                let dayButtonBottomEdgeInset = self.calendarDayHeight/4
                //当前列x坐标
                let positionX = (CGFloat(aWeekday - 1) * self.calendarDayWidth) - 1
                //当前日期位置
                let dayFrame = CGRect(x: positionX, y: positionY, width: self.calendarDayWidth, height: self.calendarDayHeight)
                //转换成格式化日期
                var dayComponents = calendar.dateComponents([Calendar.Component.day], from: dayDate)
                //创建一个日期按钮，样式为UIButtonTypeCustom
                let dayButton = UIButton()
                dayButton.isOpaque = true
                dayButton.clipsToBounds = false
                dayButton.clearsContextBeforeDrawing = false
                dayButton.frame = dayFrame
//                dayButton.titleLabel?.shadowOffset = CGSize(width: 0, height: 0)
                dayButton.titleLabel?.font = UIFont.systemFont(ofSize: self.calendarDayHeight * S_CALENDARDAYFOUNTSIZESCALE)
                dayButton.tag = aDatesIndex.count                            //tag(当前个数)
                dayButton.adjustsImageWhenHighlighted = false                     //变化时发光
                dayButton.adjustsImageWhenDisabled = false                        //变化时禁用
                //dayButton.showsTouchWhenHighlighted = true                    //点击时发光
                dayButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: dayButtonBottomEdgeInset, right: 0)
                //设置日期颜色
                var titleColor = PRTheme.current().weekdayInMonthColor
                //如果日期和当前日期间隔大于1个月（不是本月的日期），则使用不同的颜色
                if logic.distanceOfDateFromCurrentMonth(date: dayDate) != 0 {
                    if (aWeekday == 1 || aWeekday == self.numberOfDaysInWeek) {
                        titleColor = PRTheme.current().weekendOutMonthColor
                    } else {
                        titleColor = PRTheme.current().weekdayOutMonthColor
                    }
                } else {
                    if (aWeekday == 1 || aWeekday == self.numberOfDaysInWeek) {
                        titleColor = PRTheme.current().weekendInMonthColor
                    }
                }
                
                dayButton.setTitle(String.init(format: "%i", dayComponents.day!), for: UIControlState.normal)
                dayButton.setTitleColor(titleColor, for: UIControlState.selected)
//                dayButton.setTitleShadowColor(UIColor.black, for: UIControlState.selected)
                if (dayDate.compare(todayDate) != ComparisonResult.orderedSame) {
                    dayButton.setTitleColor(titleColor, for: UIControlState.normal)
//                    dayButton.setTitleShadowColor(UIColor.black, for: UIControlState.normal)
                    dayButton.setBackgroundImage(PRThemedImage(name: "CalendarDayTile.png"), for: UIControlState.normal)
                    dayButton.setBackgroundImage(PRThemedImage(name: "CalendarDaySelected.png"), for: UIControlState.selected)
                } else {
                    dayButton.setTitleColor(titleColor, for: UIControlState.normal)
//                    dayButton.setTitleShadowColor(UIColor.black, for: UIControlState.normal)
                    dayButton.setBackgroundImage(PRThemedImage(name: "CalendarDayToday.png"), for: UIControlState.normal)
                    dayButton.setBackgroundImage(PRThemedImage(name: "CalendarDayTodaySelected.png"), for: UIControlState.selected)
                    //创建图像视图，今天
                    let todayMark = PRBaseImageView(image: PRThemedImage(name: "CalendarDayTodayMark.png"))
                    //[todayMark setFrame:];
                    todayMark.contentMode = UIViewContentMode.topLeft
                    todayMark.frame = dayButton.frame
                    self.addSubview(todayMark)
                }
                //添加阴历和节日信息
                let bottomLabel = UILabel()
                let bottomLabelHeight = self.calendarDayHeight * S_CALENDARDAYBUTTOMFOUNTSIZESCALE
                bottomLabel.text = PRLunarDate.lunarDateWithNSDate(date: dayDate).priorityLabel
                
                bottomLabel.font = UIFont.systemFont(ofSize: bottomLabelHeight)
                bottomLabel.frame = CGRect(x: 0, y: dayButton.frame.size.height - bottomLabelHeight - dayButtonBottomEdgeInset + 2, width: dayButton.frame.size.width, height: bottomLabelHeight + 2)
                bottomLabel.textAlignment = NSTextAlignment.center;
                //根据标签类型修改文本颜色
                let dayType = PRLunarDate.lunarDateWithNSDate(date: dayDate).priorityLabelType
                if logic.distanceOfDateFromCurrentMonth(date: dayDate) != 0 {
                    switch dayType {
                    case .day:
                        bottomLabel.textColor = PRTheme.current().weekdayOutMonthColor
                    case .solarterm:
                        bottomLabel.textColor = PRTheme.current().sosolarTermOutMonthColor
                    default:
                        bottomLabel.textColor = PRTheme.current().festivalOutMonthColor
                    }
                } else {
                    switch dayType {
                    case .day:
                        bottomLabel.textColor = PRTheme.current().weekdayInMonthColor
                    case .solarterm:
                        bottomLabel.textColor = PRTheme.current().sosolarTermInMonthColor
                    default:
                        bottomLabel.textColor = PRTheme.current().festivalInMonthColor
                    }
                }
  
                bottomLabel.backgroundColor = UIColor.clear
                dayButton.insertSubview(bottomLabel, at: 0)
                dayButton.addTarget(self, action: #selector(dayButtonPressed), for: .touchUpInside)
                
                if aWeek == self.numberOfWeeks - 1 && aWeekday == 1 {
                    if logic.distanceOfDateFromCurrentMonth(date: dayDate) != 0 {
                        continueDraw = false
                        // 最后一行都不在本月内，不予绘制
                        self.requiredHeight = self.requiredHeight - self.calendarDayHeight
                        var vFrame = self.frame
                        vFrame.size.height = self.requiredHeight
                        self.frame = vFrame
                    }
                }
                if continueDraw {
                    self.addSubview(dayButton)
                }
                aButtonsIndex.add(dayButton)
                aDatesIndex.add(dayDate)
            }
        }
        // save
        //保存日历逻辑
        self.calendarLogic = logic
        //保存日期数组
        self.datesIndex = NSArray(array: aDatesIndex) as! Array<Date>
        //保存按钮数组
        self.buttonsIndex = NSArray(array: aButtonsIndex) as! Array<UIButton>
    }
    
    // MARK: Public Method
    
    /// 通过日期查找视图中的日期索引，不存在则返－1
    ///
    /// - Parameter date:
    /// - Returns:
    func findIndex(date: Date) -> Int {
        for i in 0...(self.datesIndex.count - 1) {
            let tmpDate = self.datesIndex[i]
            if tmpDate.compare(date) == ComparisonResult.orderedSame {
                return i
            }
        }
        return -1
    }
    
    /// 删除指定日期上指定位置的标记
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - location: 相对位置
    func removeMark(date: Date, location: PRCalendarMonthMarkLocation) {
        let remark:PRBaseImageView? = self.markDict.object(forKey: date) as? PRBaseImageView
        if remark != nil {
            remark?.removeFromSuperview()
            self.markDict.removeObject(forKey: date)
        }
    }
    
    /// 在指定日期上添加一个标记
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - imageName: 用做标记的图片
    ///   - location: 相对位置
    func addMark(date: Date, imageName: String, location: PRCalendarMonthMarkLocation) {
        let dateIndex = self.findIndex(date: date)
        if dateIndex == -1 {
            return;
        }
        let button = self.buttonsIndex[dateIndex]
        self.removeMark(date: date, location: PRCalendarMonthMarkLocation.defaultt)
        let mark = PRBaseImageView(image: PRThemedImage(name: imageName))
        switch location {
        case .topRight:

            break
        case .bottomRight:

            break
        case .defaultt:
            mark.frame = CGRect(x: 0, y: button.frame.size.height/2, width: button.frame.size.width, height: S_CALENDARDAYMARKHEIGHT)
            //mark.autoresizingMask = UIViewAutoresizing.None
        }
        //保存
        self.markDict[date] = mark
        //插入到视图
        button.insertSubview(mark, at: 0)
    }
    
    /// 选中指定日期
    ///
    /// - Parameter date:
    func selectButton(date: Date?) {
//        if self.selectedDate != nil {
//            if ((date?.compare(self.selectedDate!)) == ComparisonResult.orderedSame) {
//                return
//            }
//        }
        // 如果当前有选择，则先取消
        if self.selectedButton >= 0 {
            // 获得今天的期日
            let todayDate = PRCalendarLogic.dateForToday()
            // 获得当前选择的按钮（通过当前选择按钮索引）
            let button = self.buttonsIndex[self.selectedButton]
            // 获得当前选择按钮的位置
            var selectedFrame = button.frame
            if self.selectedDate?.compare(todayDate) != ComparisonResult.orderedSame {
                // 计算弹起后位置
//                selectedFrame.origin.y += 1
                selectedFrame.size.width = self.calendarDayWidth
                selectedFrame.size.height = self.calendarDayHeight
            }
            // 取消选择
            button.isSelected = false;           // 按钮处于未选中状态，样式会随之更改
            // 重置位置（弹起）
            button.frame = selectedFrame;
            // 当前选择置空
            self.selectedButton = -1;
            self.selectedDate = nil;
        }
        if self.calendarLogic?.distanceOfDateFromCurrentMonth(date: date) != 0 {
            return
        }
        //如果要选中的期日不为空
        if date != nil {
            // Save
            // 保存当前选择的按钮索引和日期
            self.selectedButton = self.calendarLogic?.indexOfCalendar(date: date!)
            self.selectedDate = date;
            
            // 获得今天的日期和当前被选中的按钮
            let todayDate = PRCalendarLogic.dateForToday()
            let button = self.buttonsIndex[self.selectedButton] //通过刚保存的按钮索引获得
            // 获得被选中按钮的位置
            let selectedFrame = button.frame;
            // 如果被选中的不是今天
            if date?.compare(todayDate) != ComparisonResult.orderedSame {
                // 计算压入后位置
                //selectedFrame.origin.y = selectedFrame.origin.y - 1
                //selectedFrame.size.width = calendarDayWidth + 1
                //selectedFrame.size.height = calendarDayHeight + 1
            }
            
            // 按钮被选择
            button.isSelected = true          //按钮处于被选中状态，样式会随之更改
            button.frame = selectedFrame
            //将button显示在当前视图的前面
            //[self bringSubviewToFront:button];
        }
    }
    
    /// 日期被点击
    ///
    /// - Parameter sender: 
    func dayButtonPressed(sender: UIButton) {
        //设置日历逻辑的参考日期为被选择的日期（被选择按钮的tag对应的日期）
        self.calendarLogic?.referenceDate = self.datesIndex?[sender.tag]
    }
}
