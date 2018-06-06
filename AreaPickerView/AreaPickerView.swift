//
//  AreaPickerView.swift
//  GeneralBear
//
//  Created by YAMYEE on 2018/6/4.
//  Copyright © 2018年 YAMYEE. All rights reserved.
//

import UIKit

let Width = UIScreen.main.bounds.width
let Height = UIScreen.main.bounds.height
let textColor:UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
let separatorColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)

let bigCity = ["北京","上海","天津","重庆","香港","澳门","台湾"]

let saveProvince = "saveProvince"
let saveCity = "saveCity"
let saveArea = "saveArea"

protocol AreaPickerViewDelegate: NSObjectProtocol {
    
    func areaPickerView(pickerView:UIPickerView,didSelected province:(id:String,name:String),city:(id:String,name:String),area:(id:String,name:String))

}

class AreaPickerView: UIView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var provinceData = Array<(id:String,name:String)>()
    private var cityData = Array<(id:String,name:String)>()
    private var areaData = Array<(id:String,name:String)>()
    private var selectedProvince = (id:"",name:"")
    private var selectedCity = (id:"",name:"")
    private var selectedArea = (id:"",name:"")
    var isAreaShow = true
    var isSaveHistory = true
    var delegate:AreaPickerViewDelegate?

    
    //MARK:setup
    private func setup() {
        
        let view = Bundle.main.loadNibNamed("AreaPicker", owner: self, options: nil)?.first as! UIView
        view.frame = self.frame
        addSubview(view)
        addLine(for: boxView)
    }
    
    private func eventBinding() {
        

        backView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCancleButtonClick))
        backView.addGestureRecognizer(tap)
    }
    //MARK:data
    private func initData() {
        
        if isAreaShow == false {
            loadNoAreaData()
            return
        }
        
        //刷新第一列表
        if selectedProvince.id.isEmpty == false {
            
            var index = 0
            for (id,_) in provinceData{
                if id == selectedProvince.id{
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    break
                }
                index += 1
            }
            
        }else{
            pickerView.selectRow(0, inComponent: 0, animated: false)
            selectedProvince = provinceData[0]
        }
       //取出第二列数据
        let cityDic = AreaSource.cityOrAreaDic(id: selectedProvince.id)
        cityData.removeAll()
        for (key,value) in cityDic {
            cityData.append((id:key,name:value))
        }
        
        pickerView.reloadComponent(1)
        
        //滚动到第二列所选位置
        
        if selectedCity.id.isEmpty == false {
            var index = 0
            for (id,_) in cityData{
                if id == selectedCity.id{
                    pickerView.selectRow(index, inComponent: 1, animated: false)
                    break
                }
                index += 1
            }
            
        }else{
            
            pickerView.selectRow(0, inComponent: 1, animated: false)
            selectedCity = cityData[0]
        }
        //取出第三列数据
        let areaDic = AreaSource.cityOrAreaDic(id: selectedCity.id)
        areaData.removeAll()
        
        for (key,value) in areaDic {
            areaData.append((id:key,name:value))
        }
        pickerView .reloadComponent(2)
        //滚动到第三列所选位置
        if selectedArea.id.isEmpty == false {
            var index = 0
            for (id,_) in areaData{
                if id == selectedArea.id{
                    pickerView.selectRow(index, inComponent: 2, animated: false)
                    break
                }
                index += 1
            }

        }else{
            pickerView.selectRow(0, inComponent: 2, animated: false)
            if areaData.count > 0{
                selectedArea = areaData[0]
            }
        }
    }
    func loadNoAreaData() {
        
        //滑动到所选省份
        if selectedProvince.id.isEmpty == false {
            
            var index = 0
            for (id,_) in provinceData{
                if id == selectedProvince.id{
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    break
                }
                index += 1
            }
    
        }else{
            
            pickerView.selectRow(0, inComponent: 0, animated: false)
            selectedProvince = provinceData[0]
        }
        
        var cityDic = [String:String]()
        //判断如果为港澳台及直辖市则把三级放到二级
        if bigCity.contains(selectedProvince.name) {
            
            cityDic = AreaSource.cityOrAreaDic(id: selectedCity.id)
        }else{
            cityDic = AreaSource.cityOrAreaDic(id: selectedProvince.id)
        }
        
        cityData.removeAll()
        
        for (key,value) in cityDic {
            cityData.append((id:key,name:value))
        }
        
        pickerView.reloadComponent(1)
        
        if selectedArea.id.isEmpty == false {
            
            var index = 0
            for (id,_) in cityData{
                if id == selectedArea.id{
                    pickerView.selectRow(index, inComponent: 1, animated: false)
                    break
                }
                index += 1
            }
            
        }else{
            pickerView.selectRow(0, inComponent: 1, animated: false)
            selectedArea = cityData[0]
        }
    }
    func loadProvinceData() {
        
        if isSaveHistory {
            let pro = UserDefaults.standard.string(forKey: saveProvince) ?? ""
            let city = UserDefaults.standard.string(forKey: saveCity) ?? ""
            let area = UserDefaults.standard.string(forKey: saveArea) ?? ""
            
            selectedProvince = AreaSource.getProvince(idName: pro)
            selectedCity = AreaSource.getCity(provinID: selectedProvince.id, city: city)
            selectedArea = AreaSource.getArea(cityID: selectedCity.id, area: area)
        }
        provinceData.removeAll()
        
        for (key,value) in AreaSource.provinceDic() {
            provinceData.append((id:key,name:value as! String))
        }
        pickerView.reloadComponent(0)
    }
    //MARK:event respond

    @IBAction func onCancleButtonClick(_ sender: Any){
        
        
        dismiss()
    }
    
    @IBAction func onSureButtonClick(_ sender: Any){
        
        UserDefaults.standard.set(selectedProvince.id, forKey: saveProvince)
        UserDefaults.standard.set(selectedCity.id, forKey: saveCity)
        UserDefaults.standard.set(selectedArea.id, forKey: saveArea)
        
        delegate?.areaPickerView(pickerView: self.pickerView, didSelected: selectedProvince, city: selectedCity, area: selectedArea)
        
        dismiss()
    }

    private func showAnimate() {
        if let view = UIApplication.shared.keyWindow{
            view.addSubview(self)
            self.boxView.frame = CGRect(x: 0, y: Height, width: ScreenWidth, height: 220)
            self.backView.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.boxView.frame = CGRect(x: 0, y: Height-220, width: ScreenWidth, height: 220)
                self.backView.alpha = 0.4
            })
        }
    }
    func  dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.boxView.frame = CGRect(x: 0, y: Height, width: ScreenWidth, height: 220)
            self.backView.alpha = 0
        }) { (_) in
            
            self.removeFromSuperview()
        }
    }
    //MARK:public
    func show() {
        
        loadProvinceData()
        initData()
        showAnimate()
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
        eventBinding()
    }
    override private init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        eventBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addLine(for view:UIView) {
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 45, width: Width, height: 1)
        layer.backgroundColor = separatorColor.cgColor
        view.layer.addSublayer(layer)
    }
}

extension AreaPickerView: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return isAreaShow ? 3 : 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return self.provinceData.count
        }else if component == 1{
            return self.cityData.count
        }else{
            return self.areaData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 15)
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = textColor
        }
        var title = ""
        if component == 0 {
            
            title = provinceData[row].name
            
        }else if component == 1{
            title = cityData[row].name
            
        }else{
            title = areaData[row].name
        }
        pickerLabel?.text = title
        return pickerLabel!
    }
}

extension AreaPickerView: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return Width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            selectedProvince = provinceData[row]
            selectedCity = (id:"",name:"")
            selectedArea = (id:"",name:"")
        }else if component == 1{
            
            selectedCity = cityData[row]
            selectedArea = (id:"",name:"")
            if isAreaShow == false{
                selectedArea = cityData[row]
            }
        }else{
            selectedArea = areaData[row]
        }
        initData()
    }
}

