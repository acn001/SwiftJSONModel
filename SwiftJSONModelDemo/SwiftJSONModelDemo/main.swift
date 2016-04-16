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

class Shop: SwiftJSONModel {
    
    var shopId: Int = 0
    var shopName: String?
    var shopAddress: String?
    var isOldShop: Bool {
        return shopId > 0 && shopId < 100000000
    }
    
    override func ignoredProperties() -> [String] {
        var result = ["isOldShop"]
        for item in super.ignoredProperties() {
            result.append(item)
        }
        return result
    }
    
}

class BookShop: Shop {
    
    var books: [Book]?
    
    override func genericTypes() -> [String : String] {
        var result = ["books" : String(Book)]
        for (k, v) in super.genericTypes() {
            result[k] = v
        }
        return result
    }
    
}

class Book: SwiftJSONModel {
    
    var name: String?
    var price: Int = 0
    
}

let JSONDictionary = [
    "shopId" : 200010000,
    "shopName" : "Wisdom Bookshop",
    "shopAddress" : "No 7, Fortune Rd.",
    "books" : [
        [
            "name" : "Data Mining",
            "price" : 825
        ],
        [
            "name" : "Data Analysis",
            "price" : 750
        ]
    ]
]

let bookshop = BookShop(dictionary: JSONDictionary)
if !bookshop.isOldShop {
    bookshop.shopName? = "New Wisdom Bookshop"
}
print(bookshop.toDictionary())
