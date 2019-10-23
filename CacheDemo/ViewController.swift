//
//  ViewController.swift
//  CacheDemo
//
//  Created by 许巍杰 on 2019/8/19.
//  Copyright © 2019 许巍杰. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        insert()
//        testInsertStudentWithPhotoBook()
//        testInsertManyStudent()
//        qurey()
//        testSearchStudentByID()
//        testSearchTermStudent()
//        testUpdateStudent()
//        testUpdateStudents()
//        testUpdateColumnStudents()
        testDeleteStudents()
    }
    
    // MARK: 插入
    func insert() {
        let stu = Student()
        
        stu.name = "张伟2"
        
        stu.age = 26
        
        stu.id = 2
        
        
        let birthdayStr = "1998-08-08"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        stu.birthday = dateFormatter.date(from: birthdayStr) as NSDate?
        
        stu.weight = 68
        
        stu.address = "公主坟"
        
        // 插入数据
        CacheManager.shared.insertData(obj: stu)
    }
    
    // 插入一个拥有多本书且有头像的学生对象
    func testInsertStudentWithPhotoBook() {
        let stu = Student()
        stu.name = "张伟_有头像_有书"
        stu.weight = 151
        stu.age = 26
        stu.id = 3
        // 头像
        stu.setPhotoWitName("cat")
        
        let bookFubaba = Book(value: ["富爸爸穷爸爸", "[美]罗伯特.T.清崎"])
        let bookShengmingbuxi = Book(value: ["生命不息, 折腾不止", "罗永浩"])
        let bookDianfuzhe = Book(value: ["颠覆着: 周鸿祎自传", "周鸿祎"])
        stu.books.append(bookFubaba)
        stu.books.append(bookShengmingbuxi)
        stu.books.append(bookDianfuzhe)
        
        CacheManager.shared.insertData(obj: stu)
    }
    
    // 测试在数据库中插入多个拥有多本书并且有头像的学生对象
    func testInsertManyStudent() {
        
        var stus : [Student] = []
        
        for i in 100..<121 {
            let stu = Student()
            stu.name = "张伟_\(i)"
            stu.weight = 50 + i
            stu.age = 26
            stu.id = i
            // 头像
            stu.setPhotoWitName("cat")
            let birthdayStr = "1993-06-10"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            stu.birthday = dateFormatter.date(from: birthdayStr) as NSDate?
            stus.append(stu)
        }
        
        CacheManager.shared.insertDatas(objs: stus)
        
    }
    
    
    // MARK: 查询
    func qurey() {
        let stus = CacheManager.shared.getDatas(with: NSStringFromClass(Student.self))
        for stu in stus {
            if stu.isKind(of: Student.self) {
                // 父类转成子类
                let newStu = Student(value: stu)
                print(newStu.name)
                if newStu.photo != nil {
                    let _ = newStu.getPhotoImage()
                }
                if newStu.books.count > 0 {
                    for book in newStu.books {
                        print(book.name + "+" + book.author)
                    }
                }
            }
        }
    }
    
    // 主键查询
    // 通过主键查询
    func testSearchStudentByID(){
        let student = CacheManager.shared.getDataByPrimeKey(key: 110, classType: NSStringFromClass(Student.self))
        let studentL = Student(value: student)
        print(studentL.name)
    }
    
    // 通过特定条件查询
    func testSearchTermStudent() {
        // 要注意查询条件，参数要与存储的类型对应，否则会造成崩溃
        // 实际项目开发中可以写带参数的方法，避免出现意外情况
        let students = CacheManager.shared.getDatasWithCondition("age = 26 and weight = 68", with: NSStringFromClass(Student.self))
        if students.count == 0 {
            print("未找到任何数据")
            return
        }
        for student in students {
            let studentL = Student(value: student)
            print(studentL.name, studentL.age, studentL.weight)
        }
    }
    
    // 修改数据
    func testUpdateStudent() {
        let stu = Student()
        stu.name = "张伟_110"
        stu.weight = 99
        stu.age = 39
        stu.id = 110
        // 头像
        stu.setPhotoWitName("cat")
        let birthdayStr = "1943-06-10"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        stu.birthday = dateFormatter.date(from: birthdayStr) as NSDate?
        CacheManager.shared.updateData(obj: stu)
    }
    
    // 批量修改数据
    func testUpdateStudents() {
        var stus : [Student] = []
        
        for i in 100..<111 {
            let stu = Student()
            stu.name = "张伟_深不见底"
            stu.weight = 100 + i
            stu.age = i - 80
            stu.id = i
            // 头像
            stu.setPhotoWitName("cat")
            let birthdayStr = "199\(i - 100)-06-10"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            stu.birthday = dateFormatter.date(from: birthdayStr) as NSDate?
            stus.append(stu)
        }
        
        CacheManager.shared.updateDatas(objs: stus)
    }
    
    // 批量修改键值数据
    func testUpdateColumnStudents() {
        CacheManager.shared.updateKeyColumn(classType: NSStringFromClass(Student.self), key: "age", value: 18)
    }
    
    // 删除数据
    func testDeleteStudents() {
//        // 删除单个数据
//        let student = CacheManager.shared.getDataByPrimeKey(key: 110, classType: NSStringFromClass(Student.self))
//        CacheManager.shared.deleteData(obj: student)
        
        // 删除多条数据
        let students = CacheManager.shared.getDatasWithCondition("age = 18 and weight = 68", with: NSStringFromClass(Student.self))
        CacheManager.shared.deleteDatas(objs: students)
    }
}

