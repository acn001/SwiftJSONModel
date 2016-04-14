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

enum SwiftJSONModelErrorCode: Int {
    
    // etc.
    case SwiftJSONModelTypeConvertionErrorOfStringFromCString = -51
    
    // About SwiftJSONModelObjcReflection
    case SwiftJSONModelObjcPropertyCannotBeReflected = -11
    case SwiftJSONModelObjcPropertyNameCannotBeReflected = -12
    case SwiftJSONModelObjcPropertyTypeCannotBeReflected = -13
    case SwiftJSONModelObjcNotSupportedProperty = -14
    
    // About SwiftJSONModelNetworkHelper
    case SwiftJSONModelResponseDataStructureError = -101
    
    var description: String {
        switch self {
        case .SwiftJSONModelObjcPropertyCannotBeReflected:
            return "SwiftJSONModelObjcReflection error: some property cannot be reflected.  "
        case .SwiftJSONModelObjcPropertyNameCannotBeReflected:
            return "SwiftJSONModelObjcReflection error: some property name cannot be reflected.  "
        case .SwiftJSONModelObjcPropertyTypeCannotBeReflected:
            return "SwiftJSONModelObjcReflection error: some property type cannot be reflected.  "
        case .SwiftJSONModelObjcNotSupportedProperty:
            return "SwiftJSONModelObjcReflection error: not supported property type found.  "
        case .SwiftJSONModelTypeConvertionErrorOfStringFromCString:
            return "Convertion error: construct object of String from CSting failed.  "
        case .SwiftJSONModelResponseDataStructureError:
            return "Response data structure error: "
        default:
            return "Current error code has no description with raw value: \(rawValue).  "
        }
    }
    
}
