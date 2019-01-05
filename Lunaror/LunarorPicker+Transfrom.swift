//
//  LunarorPicker+Transfrom.swift
//  Lunaror
//
//  Created by YiGan on 2019/1/5.
//  Copyright © 2019 YiGan. All rights reserved.
//

import Foundation
extension LunarorPicker {
    
    ///公历转农历
    func transformSolarToLunar(withSolarDate solarDate: Date) -> LunarDate {
        //1900-01-01==1900-01-31
        let lunarDate = LunarDate()
        
        let beginDate = transformStringToDate(withString: "1900-01-31", withFormat: "yyyy-MM-dd")
        
        let intervalTime = solarDate.timeIntervalSince(beginDate)
        var totalDays = Int(intervalTime / 24 / 60 / 60)
        
        //遍历年份
        for lunarData in lunarDataList {
            lunarDate.year = lunarData.year
           
                //遍历月份
                for (index, days) in lunarData.monthList.enumerated() {
                    lunarDate.month = index + 1
                    if totalDays - days < 0 {
                        lunarDate.isLeapMonth = false
                        lunarDate.day = totalDays
                        return lunarDate
                    }
                    totalDays -= days
                    
                    //减去闰月天数
                    if lunarData.hasLeapMonth && lunarData.leapMonth == index + 1 {     //有闰月情况
                        let leapDays = lunarData.isFullLeapMonth ? 30 : 29
                        if totalDays - leapDays < 0 {
                            lunarDate.isLeapMonth = true
                            lunarDate.day = totalDays
                            return lunarDate
                        }
                        
                        totalDays -= leapDays
                    }
                }
        }
        
        return lunarDate
    }
    
    ///农历转公历
    func transformLunarToSolar(withLunarDate lunarDate: LunarDate) -> Date {
        var totalDays = 0
        //遍历年份
        for lunarData in lunarDataList {
            if lunarData.year >= lunarDate.year {           //所在年份
                for (index, days) in lunarData.monthList.enumerated() {
                    if index + 1 >= lunarDate.month {
                        if lunarDate.isLeapMonth {      //闰月
                            totalDays += days
                            totalDays += lunarDate.day
                        }else {                         //非闰月
                            totalDays += lunarDate.day
                        }
                        break
                    }else {
                        totalDays += days
                    }
                }
            }else {                                         //过去年份
                for days in lunarData.monthList {
                    totalDays += days
                }
                if lunarData.hasLeapMonth {
                    totalDays += lunarData.isFullLeapMonth ? 30 : 29
                }
            }
        }
        
        
        let intervalTime = Double(totalDays) * 24 * 60 * 60
        let beginDate = transformStringToDate(withString: "1900-01-31", withFormat: "yyyy-MM-dd")
        
        return Date(timeInterval: intervalTime, since: beginDate)
    }
}
