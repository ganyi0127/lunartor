//
//  LunarorPicker+PickerDelegate.swift
//  Lunaror
//
//  Created by YiGan on 2019/1/5.
//  Copyright © 2019 YiGan. All rights reserved.
//

import Foundation
extension LunarorPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {             //年
            return lunarDataList.count
        }else if component == 3 {       //时辰
            return zhiList.count
        }else {
            let yearIndex = pickerView.selectedRow(inComponent: 0)
            let lunarYearObject = lunarDataList[yearIndex]
            if component == 1 {         //月
                return lunarYearObject.hasLeapMonth ? 13 : 12
            }else {                     //日
                let monthIndex = pickerView.selectedRow(inComponent: 1)
                if lunarYearObject.hasLeapMonth && monthIndex == lunarYearObject.leapMonth {
                    return lunarYearObject.isFullLeapMonth ? 30 : 29
                }else {
                    let days = lunarYearObject.monthList[monthIndex]
                    return days
                }
                
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {                                             //年份
            let lunarYearObject = lunarDataList[row]
            return "\(lunarYearObject.year)" + "(" + lunarYearObject.gan + lunarYearObject.zhi + ")"
        }else if component == 3 {                                       //时辰
            return zhiList[row] + "时"
        }else {
            let yearIndex = pickerView.selectedRow(inComponent: 0)
            let lunarYearObject = lunarDataList[yearIndex]
            if component == 1 {                                         //月份
                if lunarYearObject.hasLeapMonth {
                    if lunarYearObject.leapMonth == row {
                        return "闰" + monthList[row]
                    }else if lunarYearObject.leapMonth < row {
                        return monthList[row - 1]
                    }
                }
                return monthList[row]
            }else {                                                     //日
                return dayList[row]
            }
        }
    }
    
    //MARK:- 点击选择
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let yearIndex = pickerView.selectedRow(inComponent: 0)
        let monthIndex = pickerView.selectedRow(inComponent: 1)
        let dayIndex = pickerView.selectedRow(inComponent: 2)
        let timeIndex = pickerView.selectedRow(inComponent: 3)
        
        let lunarYearObject = lunarDataList[yearIndex]
        
        
        if component == 0 {             //年份
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }else if component == 1 {       //月份
            pickerView.reloadComponent(2)
        }
        
        //设置年份
        let lunarDate = LunarDate()
        lunarDate.year = lunarYearObject.year
        
        //设置月份
        if lunarYearObject.hasLeapMonth {
            if lunarYearObject.leapMonth == monthIndex {        //闰月
                lunarDate.isLeapMonth = true
                lunarDate.month = monthIndex
            }else if lunarYearObject.leapMonth > monthIndex {   //闰月之前
                lunarDate.month = monthIndex + 1
            }else {                                             //闰月之后
                lunarDate.month = monthIndex
            }
        }else {
            lunarDate.month = monthIndex + 1
        }
        
        //设置日
        lunarDate.day = dayIndex + 1
        
        lunarDate.time = timeIndex
        
        //临时存储
        selectedLunarDate = lunarDate        
        selectedSolarDate = transformLunarToSolar(withLunarDate: lunarDate)
    }
}
