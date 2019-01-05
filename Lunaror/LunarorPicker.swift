//
//  LunarorPicker.swift
//  Lunaror
//
//  Created by YiGan on 2018/12/31.
//  Copyright © 2018 YiGan. All rights reserved.
//

import Foundation
import SnapKit




///农历公历选择器()
public class LunarorPicker: UIView {
    
    //MARK:- 取消按钮
    let cancelButton = UIButton()
    
    //MARK:- 确认按钮
    let confirmButtom = UIButton()
    
    //MARK:- 切换
    let pickerSegmentedControl = UISegmentedControl.init(items: ["农历", "公历"])
    
    //MARK:- 公历选择器
    let solarPickerView = UIDatePicker()
    
    //MARK:- 农历选择器
    let lunarPickerView = UIPickerView()
    
    ///高度
    let height: CGFloat = 256
    
    ///顶部高度
    let topHeight: CGFloat = 30 + 4 * 2
    
    ///宽度
    lazy var width: CGFloat = {
        return view_size.width - self.sideEdge * 2
    }()
    
    ///下边距
    let bottomEdge: CGFloat = 8
    
    ///侧边距
    let sideEdge: CGFloat = 8
    
    
    ///是否为农历选择器
    public var isLunarPicker = false {
        didSet {
            solarPickerView.isHidden = isLunarPicker
            lunarPickerView.isHidden = !isLunarPicker
            
            if pickerSegmentedControl.selectedSegmentIndex == 0 {
                if !isLunarPicker {
                    pickerSegmentedControl.selectedSegmentIndex = 1
                }
            }else {
                if isLunarPicker {
                    pickerSegmentedControl.selectedSegmentIndex = 0
                }
            }
        }
    }
    
    ///已选择的公历日期
    public internal(set) var selectedSolarDate = Date()
    
    ///已选择的农历日期
    public internal(set) var selectedLunarDate = LunarDate()
    
    //MARK:- 选择回调
    public var closure: ((_ solarDate: Date, _ lunarDate: LunarDate, _ isLunarPicker: Bool, _ isComfirm: Bool)->())?
    
    
    //MARK:- init------------------------------------------------------------------------------
    public init(withIsLunarPicker isLunarPicker: Bool = false) {
        let frame = CGRect(x: sideEdge,
                           y: view_size.height,
                           width: view_size.width - sideEdge * 2,
                           height: height)
        super.init(frame: frame)
        
        config()
        createContents()
        
        //隐藏
        self.isLunarPicker = isLunarPicker
        
        //初始化设置
        setSolarDate(withDate: Date())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        
    }
    
    private func createContents() {
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        
        confirmButtom.setTitle("确定", for: .normal)
        confirmButtom.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
        
        
        pickerSegmentedControl.selectedSegmentIndex = 0
        pickerSegmentedControl.setTitle("农历", forSegmentAt: 0)
        pickerSegmentedControl.setTitle("公历", forSegmentAt: 1)
        
        
        solarPickerView.minimumDate = transformStringToDate(withString: "1900-01-31", withFormat: "yyyy-MM-dd")
        let maxLunarDate = LunarDate()
        maxLunarDate.year = 2100
        maxLunarDate.month = 12
        maxLunarDate.day = 1
        solarPickerView.maximumDate = transformLunarToSolar(withLunarDate: maxLunarDate)
        solarPickerView.datePickerMode = .dateAndTime
        solarPickerView.minuteInterval = 30
        solarPickerView.addTarget(self, action: #selector(solarPickerChange(_:)), for: .valueChanged)
        
        lunarPickerView.delegate = self
        lunarPickerView.dataSource = self
        
        addSubview(cancelButton)
        addSubview(confirmButtom)
        addSubview(pickerSegmentedControl)
        addSubview(solarPickerView)
        addSubview(lunarPickerView)
        
        
        
        
        let buttonWidth: CGFloat = 45
        let buttonEdge: CGFloat = 4
        let buttonHeight: CGFloat = topHeight - buttonEdge * 2
        
        cancelButton.setTitle("取消", for: .normal)
        confirmButtom.setTitle("确认", for: .normal)
        
        cancelButton.snp.makeConstraints { (maker) in
            maker.top.left.equalToSuperview().offset(buttonEdge)
            maker.width.equalTo(buttonWidth)
            maker.height.equalTo(buttonHeight)
        }
        
        confirmButtom.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(buttonEdge)
            maker.width.equalTo(buttonWidth)
            maker.height.equalTo(buttonHeight)
        }
        
        solarPickerView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(topHeight)
            maker.left.right.bottom.equalToSuperview()
        }
        
        lunarPickerView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(topHeight)
            maker.left.right.bottom.equalToSuperview()
        }
        
        pickerSegmentedControl.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(buttonEdge)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
        }
     
    }
    
    //MARK:- 弹出或收起
    public func show(_ isShow: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.frame.origin = CGPoint(x: 0,
                                        y: isShow ?
                                            view_size.height - self.height - self.bottomEdge :
                                            view_size.height)
        }) { (completed) in
            
        }
    }
    
    //MARK:- 取消
    @objc private func cancel(_ sender: UIButton) {
        closure?(selectedSolarDate, selectedLunarDate, isLunarPicker, false)
    }
    
    //MARK:- 确定
    @objc private func confirm(_ sender: UIButton) {
        closure?(selectedSolarDate, selectedLunarDate, isLunarPicker, true)
    }
    
    //MARK:- 公历选中
    @objc private func solarPickerChange(_ sender: UIDatePicker) {
        let date = sender.date
        selectedSolarDate = date
        selectedLunarDate = transformSolarToLunar(withSolarDate: date)
    }
    
    //MARK:- 切换选择器
    @objc private func pickerSegmented(_ sender: UISegmentedControl) {
        isLunarPicker = sender.selectedSegmentIndex == 0
    }
}
