//
//  LunarorPicker+Setting.swift
//  Lunaror
//
//  Created by YiGan on 2018/12/31.
//  Copyright © 2018 YiGan. All rights reserved.
//

import Foundation
extension LunarorPicker {
    ///设置背景颜色
    public func setBackgroundColor(withColor color: UIColor) {
        backgroundColor = color
        
        lunarPickerView.backgroundColor = color
        solarPickerView.backgroundColor = color
    }
    
    ///设置圆角
    public func setCornerRadius(withRadius radius: CGFloat = 0) {
        layer.cornerRadius = radius
        
        lunarPickerView.layer.cornerRadius = radius
        solarPickerView.layer.cornerRadius = radius
    }
    
    ///设置取消按钮
    public func setCancelButton(withTitle title: String?, withImage image: UIImage?, for state: UIControl.State = .normal) {
        cancelButton.setTitle(title, for: state)
        cancelButton.setImage(image, for: state)
    }
    
    ///设置确认按钮
    public func setConfirmButton(withTitle title: String?, withImage image: UIImage?, for state: UIControl.State = .normal) {
        confirmButtom.setTitle(title, for: state)
        confirmButtom.setImage(image, for: state)
    }
    
    ///设置公农历切换
    public func setSegmentControl(withTitle title: String?, withImage image: UIImage?, forSegmentAt index: Int){
        guard index < pickerSegmentedControl.numberOfSegments else {
            return
        }
        pickerSegmentedControl.setTitle(title, forSegmentAt: index)
        pickerSegmentedControl.setImage(image, forSegmentAt: index)
    }
    
    ///设置农历日期
    public func setLunarDate(withLunarDate lunarDate: LunarDate){
        selectedLunarDate = lunarDate
        selectedSolarDate = transformLunarToSolar(withLunarDate: lunarDate)
        
        solarPickerView.setDate(selectedSolarDate, animated: true)
        lunarPickerView.reloadAllComponents()
    }
    
    ///设置公历日期
    public func setSolarDate(withDate date: Date) {
        selectedSolarDate = date
        selectedLunarDate = transformSolarToLunar(withSolarDate: date)
        
        solarPickerView.setDate(date, animated: true)
        lunarPickerView.reloadAllComponents()
    }
}
