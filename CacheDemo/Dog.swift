//
//  Dog.swift
//  CacheDemo
//
//  Created by 许巍杰 on 2019/8/19.
//  Copyright © 2019 许巍杰. All rights reserved.
//

import Foundation
import RealmSwift

/// 🐶数据模型
class Dog: Object {
    
    /**
     主键（Primary Keys）
     
     重写 Object.primaryKey() 可以设置模型的主键。声明主键之后，对象将允许进行查询，并且更新速度更加高效，而这也会要求每个对象保持唯一性。 一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
     
     Realm 可以将 Int 和 String 类型的属性设为主键，但是不支持自增长属性，所以只能自己给主键生成一个唯一的标识，可以使用 UUID().uuidString 方法生成唯一主键。
     */
//    dynamic var id = UUID().uuidString
//    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    
    
    dynamic var firstName = ""
    
    dynamic var lastName = ""
    
    dynamic var name = ""
    
    
    dynamic var age : Int = 0
    
    
    /**
     如果对多关系属性 Person.dogs 链接了一个 Dog 实例，而这个实例的对一关系属性 Dog.owner 又链接到了对应的这个 Person 实例，那么实际上这些链接仍然是互相独立的。
     
     为 Person 实例的 dogs 属性添加一个新的 Dog 实例，并不会将这个 Dog 实例的 owner 属性自动设置为该 Person。
     
     但是由于手动同步双向关系会很容易出错，并且这个操作还非常得复杂、冗余，因此 Realm 提供了 链接对象 (linking objects) 属性来表示这些反向关系
     */
    let owner = LinkingObjects(fromType: Person.self, property: "dogs") // 反向关系
    
    
    /**
     忽略属性（Ignored Properties）
     重写 Object.ignoredProperties() 可以防止 Realm 存储数据模型的某个属性。Realm 将不会干涉这些属性的常规操作，它们将由成员变量提供支持，并且您能够轻易重写它们的 setter 和 getter 。
     */
//    override class func ignoredProperties() -> [String] {
//        
//        return ["name"]
//    }
    
}

/// 🐩主人的数据模型
class Person: Object {
    
    dynamic var name : String?
    var birthday = NSDate()
    let dogs = List<Dog>()
    
    /**
     索引属性（Indexed Properties）
     
     重写 Object.indexedProperties() 方法可以为数据模型中需要添加索引的属性建立索引。Realm 支持字符串、整数、布尔值 以及 NSDate 属性作为索引。对属性进行索引可以减少插入操作的性能耗费，加快比较检索的速度（比如说 = 以及 IN 操作符）
     */
    override class func indexedProperties() -> [String] {
        return ["name"]
    }
}

