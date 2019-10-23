//
//  CacheManager.swift
//  CacheDemo
//
//  Created by 许巍杰 on 2019/9/2.
//  Copyright © 2019 许巍杰. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class CacheManager: NSObject {
    
    /// 获取存储工具对象
    static let shared = CacheManager()
    
    private var isConfig = false
    
    private var cacheDBPath = ""
    
    private override init() {
        super.init()
        if !isConfig {
            isConfig = true
            // 进行数据库配置
            configRealm()
        }
    }
    
    private func getCachePath() -> String {
        if cacheDBPath.isEmpty {
            let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
            let dbPath = docPath.appending("/cacheDB.realm")
            self.cacheDBPath = dbPath
        }
        return cacheDBPath
    }
    
    // MARK: 配置
    /// 配置数据库
    private func configRealm() {
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
        self.cacheDBPath = self.getCachePath()
        let config = Realm.Configuration(fileURL: URL.init(string: cacheDBPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: CacheConfig.schemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                print("Realm 服务器配置成功!")
            }else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
        
    }
    
    /// 获取数据库对象
    private func getDB() -> Realm {
        let dbPath = self.getCachePath()
        
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL(string: dbPath)!)
        
        return defaultRealm
    }
    
    
    // MARK: 增删改查
    /// 新增数据
    func insertData<T: Object>(obj: T) {
        
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(obj)
            
        }
        
        print(defaultRealm.configuration.fileURL ?? "")
    }
    /// 批量新增数据
    func insertDatas<T: Object>(objs: [T]) {
        
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(objs)
            
        }
        
        print(defaultRealm.configuration.fileURL ?? "")
    }
    
    
    /// 查询数据
    func getDatas(with classType: String) -> Results<DynamicObject> {
        var className = ""
        if classType.contains(".") {
            className = String(classType.split(separator: ".").last ?? "")
        }else {
            className = classType
        }
        let defaultRealm = self.getDB()
        print(defaultRealm.configuration.fileURL ?? "")
        return defaultRealm.dynamicObjects(className)
    }
    
    
    /// 按条件查询数据
    func getDatasWithCondition(_ term: String, with classType: String) -> Results<DynamicObject> {
        let defaultRealm = self.getDB()
        print(defaultRealm.configuration.fileURL ?? "")
        let predicate = NSPredicate(format: term)
        var className = ""
        if classType.contains(".") {
            className = String(classType.split(separator: ".").last ?? "")
        }else {
            className = classType
        }
        let results = defaultRealm.dynamicObjects(className)
        return results.filter(predicate)
    }
    
    
    /**
     
     升序/降序 查询
     
     // 根据名字升序查询
     let stus = realm.objects(Student.self).sorted(byKeyPath: "id")
     
     // 根据名字降序序查询
     let stus = realm.objects(Student.self).sorted(byKeyPath: "id", ascending: false)
     
     */
    
    
    /// 通过主键查询
    func getDataByPrimeKey(key: Any, classType: String) -> DynamicObject {
        
        let defaultRealm = self.getDB()
        var className = ""
        if classType.contains(".") {
            className = String(classType.split(separator: ".").last ?? "")
        }else {
            className = classType
        }
        print(defaultRealm.configuration.fileURL ?? "")
        return defaultRealm.dynamicObject(ofType: className, forPrimaryKey: key) ?? DynamicObject()
    }
    
    
    /// 修改数据 - 主键更新
    func updateData<T: Object>(obj: T) {
        
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(obj, update: .modified)
        }
    }
    
    /// 批量更新数据
    func updateDatas<T: Object>(objs: [T]) {
        
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(objs, update: .modified)
        }
    }
    
    /// 键值更新
    func updateKeyColumn(classType: String, key: String, value: Any) {
        let defaultRealm = self.getDB()
        var className = ""
        if classType.contains(".") {
            className = String(classType.split(separator: ".").last ?? "")
        }else {
            className = classType
        }
        try! defaultRealm.write {
            let objs = defaultRealm.dynamicObjects(className)
            objs.setValue(value, forKey: key)
        }
    }
    
    
    /// 删除单个
    func deleteData<T: Object>(obj: T) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.delete(obj)
        }
    }
    
    /// 删除多个
    func deleteDatas<T: Object>(objs: Results<T>) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.delete(objs)
        }
    }
    
}
