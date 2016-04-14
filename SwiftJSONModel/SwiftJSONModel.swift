//
//  SwiftJSONModel.swift
//  SWiftJSONModel
//
//  @version 0.1
//  @author Zhu Yue(411514124@qq.com)
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Zhu Yue
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

private var propertyTypeCheckedClasses: [String] = [String]()
private var ignoredPropertiesRegisteredClasses: [String : [String]] = [String : [String]]()

class SwiftJSONModel: NSObject {
    
    required override init() {
        super.init()
        if !propertyTypeCheckedClasses.contains(NSStringFromClass(self.dynamicType)) {
            if checkPropertyType() {
                propertyTypeCheckedClasses.append(NSStringFromClass(self.dynamicType))
            }
        }
    }
    
    convenience init(dictionary: [String : AnyObject]) {
        self.init()
        updateWithDictionary(dictionary)
    }
    
    final private func checkPropertyType() -> Bool {
        let (properties, _) = SwiftJSONModelObjcReflection.propertiesOfClass(self.dynamicType)
        if properties != nil {
            for (propertyName, propertyType) in properties! {
                if !ignoredProperties().contains(propertyName) && propertyType != "Int" && propertyType != "Float" && propertyType != "Double" && propertyType != "NSString" && propertyType != "NSNumber" && propertyType != "NSArray" && !SwiftJSONModelObjcReflection.isClassWithName(propertyType, kindOfClass: SwiftJSONModel.self) && !SwiftJSONModelObjcReflection.isClassWithName(propertyType, kindOfClass: SwiftJSONModelIgnored.self) {
                    fatalError("\(NSStringFromClass(self.dynamicType)) has invalid property type, property name: \(propertyName), property type: \(propertyType).  Only Int, Float, Double, String / NSString, NSNumber, NSArray, SwiftJSONModel or its subclass, SwiftJSONModelIgnored or its subclass can be used.")
                }
                if propertyType == "NSArray" {
                    let genericType = getGenericTypeForArrayProperty(propertyName)
                    if genericType != "Int" && genericType != "Float" && genericType != "Double" && genericType != "NSString" && genericType != "NSNumber" && !SwiftJSONModelObjcReflection.isClassWithName(genericType, kindOfClass: SwiftJSONModel.self) {
                        fatalError("\(NSStringFromClass(self.dynamicType)) has invalid generic type with its array property, array name: \(propertyName), generic type: \(genericType).  Only Int, Float, Double, String / NSString, NSNumber, SwiftJSONModel or its subclass can be the valid generic type.")
                    }
                }
            }
        }
        return true
    }
    
    func ignoredProperties() -> [String] {
        return [String]()
    }
    
    func genericTypes() -> [String : String] {
        return [String : String]()
    }
    
    final private func getGenericTypeForArrayProperty(propertyName: String) -> String {
        if let genericType = genericTypes()[propertyName] {
            return genericType
        }
        fatalError("Array property's generic type must be specified, class: \(NSStringFromClass(self.dynamicType)), property name: \(propertyName).")
    }
    
    final func updateWithDictionary(dictionary: [String : AnyObject]) {
        let (properties, _) = SwiftJSONModelObjcReflection.propertiesOfClass(self.dynamicType)
        if properties != nil {
            for (propertyName, propertyType) in properties! {
                if !ignoredProperties().contains(propertyName) {
                    switch propertyType {
                    case "Int":
                        if let propertyValue = dictionary[propertyName] as? Int {
                            setValue(propertyValue, forKey: propertyName)
                        }
                    case "Float":
                        if let propertyValue = dictionary[propertyName] as? Float {
                            setValue(propertyValue, forKey: propertyName)
                        }
                    case "Double":
                        if let propertyValue = dictionary[propertyName] as? Double {
                            setValue(propertyValue, forKey: propertyName)
                        }
                    case "String":
                        if let propertyValue = dictionary[propertyName] as? String {
                            setValue(propertyValue, forKey: propertyName)
                        }
                    case "NSString":
                        if let propertyValue = dictionary[propertyName] as? String {
                            setValue(propertyValue, forKey: propertyName)
                        }
                    case "NSNumber":
                        if let propertyValue = dictionary[propertyName] as? NSNumber {
                            setValue(propertyValue, forKey: propertyName)
                        }
                    case "NSArray":
                        let genericType = getGenericTypeForArrayProperty(propertyName)
                        switch genericType {
                        case "Int":
                            if let propertyValue = dictionary[propertyName] as? [Int] {
                                setValue(propertyValue, forKey: propertyName)
                            }
                        case "Float":
                            if let propertyValue = dictionary[propertyName] as? [Float] {
                                setValue(propertyValue, forKey: propertyName)
                            }
                        case "Double":
                            if let propertyValue = dictionary[propertyName] as? [Double] {
                                setValue(propertyValue, forKey: propertyName)
                            }
                        case "String":
                            if let propertyValue = dictionary[propertyName] as? [String] {
                                setValue(propertyValue, forKey: propertyName)
                            }
                        case "NSString":
                            if let propertyValue = dictionary[propertyName] as? [String] {
                                setValue(propertyValue, forKey: propertyName)
                            }
                        case "NSNumber":
                            if let propertyValue = dictionary[propertyName] as? [NSNumber] {
                                setValue(propertyValue, forKey: propertyName)
                            }
                        default:
                            if SwiftJSONModelObjcReflection.isClassWithName(genericType, kindOfClass: SwiftJSONModel.self) {
                                if let arrayToParse = dictionary[propertyName] as? [[String : AnyObject]] {
                                    var propertyValue = [AnyObject]()
                                    for dictionaryToParse in arrayToParse {
                                        if let aClass = (NSClassFromString(genericType) != nil ? NSClassFromString(genericType) : NSClassFromString(SwiftJSONModelObjcReflection.getProjectNamespace() + "." + genericType)) as? SwiftJSONModel.Type {
                                            let item = aClass.init()
                                            item.updateWithDictionary(dictionaryToParse)
                                            propertyValue.append(item)
                                        }
                                    }
                                    setValue(propertyValue, forKey: propertyName)
                                }
                            }
                        }
                    default:
                        if SwiftJSONModelObjcReflection.isClassWithName(propertyType, kindOfClass: SwiftJSONModel.self) {
                            if let aClass = (NSClassFromString(propertyType) != nil ? NSClassFromString(propertyType) : NSClassFromString(SwiftJSONModelObjcReflection.getProjectNamespace() + "." + propertyType)) as? SwiftJSONModel.Type {
                                if let subDictionary = dictionary[propertyName] as? [String : AnyObject] {
                                    let propertyValue = aClass.init()
                                    propertyValue.updateWithDictionary(subDictionary)
                                    setValue(propertyValue, forKey: propertyName)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    final func toDictionary() -> [String : AnyObject] {
        var dictionary = [String : AnyObject]()
        let (properties, _) = SwiftJSONModelObjcReflection.propertiesOfClass(self.dynamicType)
        if properties != nil {
            for (propertyName, propertyType) in properties! {
                if !ignoredProperties().contains(propertyName) {
                    switch propertyType {
                    case "Int":
                        if let propertyValue = valueForKey(propertyName) as? Int {
                            dictionary[propertyName] = propertyValue
                        }
                    case "Float":
                        if let propertyValue = valueForKey(propertyName) as? Float {
                            dictionary[propertyName] = propertyValue
                        }
                    case "Double":
                        if let propertyValue = valueForKey(propertyName) as? Double {
                            dictionary[propertyName] = propertyValue
                        }
                    case "String":
                        if let propertyValue = valueForKey(propertyName) as? String {
                            dictionary[propertyName] = propertyValue
                        }
                    case "NSString":
                        if let propertyValue = valueForKey(propertyName) as? String {
                            dictionary[propertyName] = propertyValue
                        }
                    case "NSNumber":
                        if let propertyValue = valueForKey(propertyName) as? NSNumber {
                            dictionary[propertyName] = propertyValue
                        }
                    case "NSArray":
                        let genericType = getGenericTypeForArrayProperty(propertyName)
                        switch genericType {
                        case "Int":
                            if let propertyValue = valueForKey(propertyName) as? [Int] {
                                dictionary[propertyName] = propertyValue
                            }
                        case "Float":
                            if let propertyValue = valueForKey(propertyName) as? [Float] {
                                dictionary[propertyName] = propertyValue
                            }
                        case "Double":
                            if let propertyValue = valueForKey(propertyName) as? [Double] {
                                dictionary[propertyName] = propertyValue
                            }
                        case "String":
                            if let propertyValue = valueForKey(propertyName) as? [String] {
                                dictionary[propertyName] = propertyValue
                            }
                        case "NSString":
                            if let propertyValue = valueForKey(propertyName) as? [String] {
                                dictionary[propertyName] = propertyValue
                            }
                        case "NSNumber":
                            if let propertyValue = valueForKey(propertyName) as? [NSNumber] {
                                dictionary[propertyName] = propertyValue
                            }
                        default:
                            if SwiftJSONModelObjcReflection.isClassWithName(genericType, kindOfClass: SwiftJSONModel.self) {
                                if let arrayToParse = valueForKey(propertyName) as? [SwiftJSONModel] {
                                    var propertyValue = [[String : AnyObject]]()
                                    for item in arrayToParse {
                                        propertyValue.append(item.toDictionary())
                                    }
                                    dictionary[propertyName] = propertyValue
                                }
                            }
                        }
                    default:
                        if SwiftJSONModelObjcReflection.isClassWithName(propertyType, kindOfClass: SwiftJSONModel.self) {
                            if let propertyValue = valueForKey(propertyName) as? SwiftJSONModel.Type {
                                dictionary[propertyName] = propertyValue
                            }
                        }
                    }
                }
            }
        }
        return dictionary
    }
    
}
