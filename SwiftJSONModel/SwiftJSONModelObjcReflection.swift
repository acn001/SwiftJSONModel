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

private var propertiesOfClasses: [String : [String : String]]?
private var defaultPropertiesFromNSObject: Set<String>?

final private class SwiftJSONModelDefaultNSObject: NSObject {
    
}

final class SwiftJSONModelObjcReflection: NSObject {
    
    override class func initialize() {
        propertiesOfClasses = Dictionary()
        
        var set: Set<String> = Set()
        var outCount: UInt32 = 0
        let objcProperties = class_copyPropertyList(SwiftJSONModelDefaultNSObject.self, &outCount)
        for i in 0 ..< outCount {
            let property = objcProperties[Int(i)]
            let objcPropertyName: UnsafePointer<Int8> = property_getName(property)
            if objcPropertyName != nil {
                set.insert(String.fromCString(objcPropertyName)!)
            }
            if objcPropertyName != nil {
                // TODO: Should / Can we free a pointer of UnsafePointer<T>?  If UnsafePointer<T> is equivalent to const void*, we need not free it, even cannot free it.
//                free(objcPropertyName)
            }
        }
        if (objcProperties != nil) {
            free(objcProperties);
        }
        defaultPropertiesFromNSObject = set;
    }
    
    class func isClass(aClass: AnyClass, kindOfClass: AnyClass) -> Bool {
        var clazz: AnyClass = aClass
        if clazz == kindOfClass.self {
            return true;
        } else {
            while true {
//                print("\(NSStringFromClass(clazz))")
                if clazz.superclass() != nil {
                    if clazz.superclass() == kindOfClass.self {
                        return true;
                    }
                    clazz = clazz.superclass()!
                } else {
                    break;
                }
            }
            return clazz == kindOfClass.self
        }
    }
    
    class func isClassWithName(className: String, kindOfClass: AnyClass) -> Bool {
        if let aClass = (NSClassFromString(className) != nil ? NSClassFromString(className) : NSClassFromString(SwiftJSONModelObjcReflection.getProjectNamespace() + "." + className)) {
            return isClass(aClass, kindOfClass: kindOfClass)
        } else {
            fatalError("Cannot find \(className) in current project.")
        }
    }
    
    private class func propertiesOfClass(aClass: AnyClass, inout propertiesOfClasses: [String : [String : String]]?) -> ([String : String]?, NSError?) {
        var clazz: AnyClass = aClass
        let clazzName = NSStringFromClass(clazz)
        var propertiesOfAClass: [String : String]? = propertiesOfClasses![clazzName]
        if propertiesOfAClass == nil {
            if !isClass(aClass, kindOfClass: NSObject.self) {
                fatalError("\(NSStringFromClass(aClass)) is not kind of NSObject.")
            }
            
            propertiesOfAClass = [String : String]()
            while clazz != NSObject.self {
                let (properties, error) = declaredPropertiesOfClass(clazz)
                if error != nil {
                    return (nil, error)
                } else {
                    for (propertyName, propertyType) in properties! {
                        propertiesOfAClass![propertyName] = propertyType
                    }
                    clazz = clazz.superclass()!
                }
            }
            propertiesOfClasses![clazzName] = propertiesOfAClass!
        }
        return (propertiesOfAClass, nil)
    }
    
    class func propertiesOfClass(aClass: AnyClass) -> ([String : String]?, NSError?) {
        return propertiesOfClass(aClass, propertiesOfClasses: &propertiesOfClasses)
    }
    
    class func declaredPropertiesOfClass(aClass: AnyClass) -> ([String: String]?, NSError?) {
        var properties = [String : String]()
        var outCount: UInt32 = 0
        let objcProperties: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &outCount)
        if objcProperties != nil {
            for i in 0 ..< outCount {
                let property = objcProperties[Int(i)]
                if property == nil {
                    let errorMessage = SwiftJSONModelErrorCode.SwiftJSONModelObjcPropertyCannotBeReflected.description + "Class: \(NSStringFromClass(aClass))."
                    print(errorMessage)
                    let error = NSError(domain: errorMessage, code: SwiftJSONModelErrorCode.SwiftJSONModelObjcPropertyCannotBeReflected.rawValue, userInfo: nil)
                    return (nil, error)
                }
                
                let objcPropertyName: UnsafePointer<Int8> = property_getName(property)
                if objcPropertyName == nil {
                    let errorMessage = SwiftJSONModelErrorCode.SwiftJSONModelObjcPropertyNameCannotBeReflected.description + "Class: \(NSStringFromClass(aClass))."
                    print(errorMessage)
                    let error = NSError(domain: errorMessage, code: SwiftJSONModelErrorCode.SwiftJSONModelObjcPropertyNameCannotBeReflected.rawValue, userInfo: nil)
                    return (nil, error)
                }
                
                let propertyName = String.fromCString(objcPropertyName)
                if propertyName == nil {
                    let errorMessage = SwiftJSONModelErrorCode.SwiftJSONModelTypeConvertionErrorOfStringFromCString.description
                    print(errorMessage)
                    let error = NSError(domain: errorMessage, code: SwiftJSONModelErrorCode.SwiftJSONModelTypeConvertionErrorOfStringFromCString.rawValue, userInfo: nil)
                    return (nil, error)
                }
                
                if objcPropertyName != nil {
                    // TODO: Should / Can we free a pointer of UnsafePointer<T>?  If UnsafePointer<T> is equivalent to const void*, we need not free it, even cannot free it.
//                    free(objcPropertyName)
                }
                
                if defaultPropertiesFromNSObject!.contains(propertyName!) {
                    continue
                }
                
                let objcPropertyType: UnsafeMutablePointer<Int8> = property_copyAttributeValue(property, "T")
                if objcPropertyType == nil {
                    let errorMessage = SwiftJSONModelErrorCode.SwiftJSONModelObjcPropertyTypeCannotBeReflected.description + "Class: \(NSStringFromClass(aClass))."
                    print(errorMessage)
                    let error = NSError(domain: errorMessage, code: SwiftJSONModelErrorCode.SwiftJSONModelObjcPropertyTypeCannotBeReflected.rawValue, userInfo: nil)
                    return (nil, error)
                }
                
                let (propertyType, error) = parsePropertyType(objcPropertyType, aClass: aClass, propertyName: propertyName!)
                if objcPropertyType != nil {
                    free(objcPropertyType)
                }
                if error != nil {
                    return (nil, error)
                }
                if propertyName != nil && propertyType != nil {
                    properties[propertyName!] = propertyType!
                }
            }
            if objcProperties != nil {
                free(objcProperties)
            }
        } else {
            print("Warning: class: \(NSStringFromClass(aClass)) reflects none properties.  This may be noramal, or some of properties cannot be reflected by objc/runtime.  Please check.")
        }
        return (properties, nil)
    }
    
    private class func parsePropertyType(objcPropertyType: UnsafePointer<Int8>, aClass: AnyClass, propertyName: String) -> (String?, NSError?) {
        let objcPropertyTypeString = String.fromCString(objcPropertyType)
        if objcPropertyTypeString == nil {
            let errorMessage = SwiftJSONModelErrorCode.SwiftJSONModelTypeConvertionErrorOfStringFromCString.description
            print(errorMessage)
            let error = NSError(domain: errorMessage, code: SwiftJSONModelErrorCode.SwiftJSONModelTypeConvertionErrorOfStringFromCString.rawValue, userInfo: nil)
            return (nil, error)
        }
        
        switch objcPropertyTypeString!.substringToIndex(objcPropertyTypeString!.startIndex.advancedBy(1)) {
        case "@":
            var propertyType = objcPropertyTypeString!.substringFromIndex(objcPropertyTypeString!.startIndex.advancedBy(2))
            propertyType = propertyType.substringToIndex(propertyType.endIndex.advancedBy(-1))
            return (propertyType, nil)
        case "c":
            return ("Int8", nil)
        case "s":
            return ("Int16", nil)
        case "i":
            return ("Int32", nil)
        case "q":
            return ("Int", nil)
        case "f":
            return ("Float", nil)
        case "d":
            return ("Double", nil)
        default:
            // Not supported property types, such as C structures, unsigned primitive types or primitive arrays.  They are not used in most cases.
            let errorMessage = SwiftJSONModelErrorCode.SwiftJSONModelObjcNotSupportedProperty.description + "Class: \(NSStringFromClass(aClass)), property name: \(propertyName), objc property type: \(objcPropertyTypeString)."
            print(errorMessage)
            let error = NSError(domain: errorMessage, code: SwiftJSONModelErrorCode.SwiftJSONModelObjcNotSupportedProperty.rawValue, userInfo: nil)
            return ("UNKNOWN", error)
        }
    }
    
}

extension SwiftJSONModelObjcReflection {
    
    final class func getProjectNamespace() -> String {
        if let infoDictionary = NSBundle.mainBundle().infoDictionary {
            if let projectNamespace = infoDictionary["CFBundleName"] as? String {
                return projectNamespace
            }
        }
        if let projectNamespace = NSStringFromClass(self).componentsSeparatedByString(".").first {
            return projectNamespace
        }
        fatalError("Project namespace should be returned here.")
    }
    
}
