# SwiftJSONModel
Data Modelling Framework for JSON in Swift.  Data model classes and instances can be easily created.

## Version 0.1
This version provides following features:<br>
* Construct a model instance with a dictionary;<br>
* Update a model with a dictionary;<br>
* Convert a model to a dictionary.<br>

## Adding SwiftJSONModel to your project
Currently, SwiftJSONModel should be integrated manually.  Follow these steps:<br>
1. Download the SwiftJSONModel repository as a [zip file](https://github.com/acn001/SwiftJSONModel/archive/master.zip) or clone it;<br>
2. Copy the SwiftJSONModel sub-folder into your Xcode project, and add it to your project.<br>

## Basic usage
Consider a JSON string like:<br>
```JSON
{
    "shopId" : 200010000,
    "shopName" : "Wisdom Bookshop",
    "shopAddress" : "No 7, Fortune Rd."
}
```
To model this JSON, you should:<br>
1. Create a new class which inherit the SwiftJSONModel class;<br>
2. Declare properties with the name of the JSON keys:<br>
```Swift
class Shop: SwiftJSONModel {

    var shopId: Int = 0
    var shopName: String?
    var shopAddress: String?
  
}
```
Currently， SwiftJSONModel can convert these types automatically in Swift:<br>
`Int`, `Float`, `Double`, `String` / `NSString`, `NSNumber`, `SwiftJSONModel` or its subclass, and `Array` / `NSArray`.  Remember that `Int, Float, and Double properties cannot be optional`.<br>
If you want to use properties of other types，you should add these properties into ignored list.  See Ignored properties in detail.<br>
3. To construct a model instance from JSON data, you can use following constructor:<br>
```Swift
convenience init(dictionary: [String : AnyObject])
```
For example:<br>
```Swift
if let JSONData: NSData = /* obtained by Internet */ {
    if let JSONDictionary = try? NSJSONSerialization.JSONObjectWithData(JSONData, options: .MutableContainers) as? [String : AnyObject] {
        let shop = Shop(dictionary: JSONDictionary!)
        if shop.shopId == 200010000 {
            shop.shopName? = "New Wisdom Bookshop"
            // ...
        }
    }
}
```

## Examples

####Model cascading (models including other models)
<table>
<tr>
<td valign="top">
<pre>
{
    "shopId" : 200010000,
    "shopName" : "Wisdom Bookshop",
    "shopAddress" : "No 7, Fortune Rd."
    "shopOwner" : {
        "ownerId" : 30001001
        "ownerName" : "Alax Hackathon"
        "mobilephone" : "800-888-7777"
    }
}
</pre>
</td>
<td valign="top">
<pre>
class BookShop: Shop {
    
    var shopOwner: Owner?
    
}

class Owner: SwiftJSONModel {
    
    var ownerId: Int = 0
    var ownerName: String?
    var mobilephone: String?
    
}
</pre>
</td>
</tr>
</table>

#### Ignored properties
You can specify the property to be ignored when converting by one of these following ways:<br>
* Composite a subclass of `SwiftJSONModelIgnored` which has the property to ignore:<br>
```Swift
class BookShop: Shop {
    
    var shopLogo: ShopLogo?
    
}

class ShopLogo: SwiftJSONModelIgnored {
    
    var image: UIImage?
    
}
```
* Override the method of `func ignoredProperties() -> [String]` to return an array of classname string:<br>
```Swift
class BookShop: Shop {
    
    var shopLogo: UIImage?
    
    override func ignoredProperties() -> [String] {
        var result = ["shopLogo"]
        for item in super.ignoredProperties() {
            result.append(item)
        }
        return result
    }
    
}
```
Remember that in an inheritance system, you should call `super.ignoredProperties()` and merge superclass's ignore list.

#### Model collections
You should specify the generic types of array collections by method of `func genericTypes() -> [String : String]`.  The valid generic type can be: `Int`, `Float`, `Double`, `String` / `NSString`, `NSNumber`, `SwiftJSONModel` or its subclass.
<table>
<tr>
<td valign="top">
<pre>
{
    "shopId" : 200010000,
    "shopName" : "Wisdom Bookshop",
    "shopAddress" : "No 7, Fortune Rd."
    "commodities" : [
        {
            "name" : "Data Mining",
            "price" : 825
        },
        {
            "name" : "Data Analysis",
            "price" : 750
        }
    ]
}
</pre>
</td>
<td valign="top">
<pre>
class BookShop: Shop {
    
    var commodities: [Commodity]?
    
    override func genericTypes() -> [String : String] {
        var result = ["commodities" : "Commodity"]
        for (k, v) in super.genericTypes() {
            result[k] = v
        }
        return result
    }
    
}

class Commodity: SwiftJSONModel {
    
    var name: String?
    var price: Int = 0
    
}
</pre>
</td>
</tr>
</table>
Remember that in an inheritance system, you should call `super.genericTypes()` and merge superclass's generic type list.<br>

#### Computed properties
Computed properties are supported in SwiftJSONModel.  You can add computed properties for a class as usual, `but remember to make them ignored`:<br>
```Swift
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
```

## Misc
Author: [Zhu Yue](mailto:411514124@qq.com)

## License
This code is distributed under the terms and conditions of the MIT license.<br>
