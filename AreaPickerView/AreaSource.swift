//
//  AreaPickerView.swift
//  GeneralBear
//
//  Created by YAMYEE on 2018/6/4.
//  Copyright © 2018年 YAMYEE. All rights reserved.
//

import UIKit

class AreaSource: NSObject {

    static func getProvince(idName:String?=nil)->(id:String,name:String){
        
        if idName == nil{
            
            return (id:"",name:"")
        }
        
        let provinceDic = self.rootDictionary()["1"] as! [String:String]
        
        for (key,value) in provinceDic{
            
            if key == idName || value == idName{
                return (id:key,name:value)
            }
        }
        return (id:"",name:"")
    }
    
    static func getCity(provinID:String,city idName:String) ->(id:String,name:String){
        
        let cityDic = cityOrAreaDic(id: provinID)
        
        for (key,value) in cityDic{
            
            if key == idName || value == idName{
                return (id:key,name:value)
            }
        }
        return (id:"",name:"")
    }
    
    static func getArea(cityID:String,area idName:String) ->(id:String,name:String){
        
        let areaDic = cityOrAreaDic(id: cityID)
        
        for (key,value) in areaDic{
            
            if key == idName || value == idName{
                return (id:key,name:value)
            }
        }
        return (id:"",name:"")
    }
    
    
    static func provinceDic()->[String:Any] {
    
        let provinceDic = rootDictionary()["1"]
        return provinceDic as! [String : Any]
    }
    
    static func cityOrAreaDic(id:String) -> [String:String] {
        
       let rootDic = rootDictionary()
        
        for (key,value)in rootDic{
            
            if key == id{
                return value as! [String:String]
            }
        }
        return [String:String]()
    }
    
    
    
    static func rootDictionary()->[String:Any]{
        
        let areaJSONPath = Bundle.main.path(forResource: "region", ofType: "json")
        
        guard areaJSONPath != nil else {
            return [String:Any]()
        }
        
        do {
            let data = try NSData(contentsOfFile: areaJSONPath!) as Data
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                return json
            }catch{
                return [String:String]()
            }
        } catch {
            
            return [String:Any]()
        }
        
    }
    
}
