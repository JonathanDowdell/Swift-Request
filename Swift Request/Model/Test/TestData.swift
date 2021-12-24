////
////  TestData.swift
////  Swift Request
////
////  Created by Jonathan Dowdell on 12/23/21.
////
//
//import CoreData
//import SwiftUI
//
//protocol TestProtocol {
//    var context: NSManagedObjectContext { get }
//    var entityName: String { get }
//    func addItems() throws
//    func getItems() throws -> [Any]?
//}
//
//class TestData: TestProtocol {
//    var context: NSManagedObjectContext
//
//    var entityName: String
//
//    init(context: NSManagedObjectContext, entityName: String) {
//        self.context = context
//        self.entityName = entityName
//    }
//
//    func addItems() throws {
//
//    }
//
//    func getItems() throws -> [Any]? {
//        try addItems()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
//        return try? context.fetch(fetchRequest)
//    }
//
//    func getItems<T>(count: Int) throws -> [T] {
//        let fullList: [T] = try self.getItems() as! [T]
//        return Array(fullList.prefix(count))
//    }
//
//    func noItemsExist() -> Bool {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
//        do {
//            return try context.count(for: fetchRequest) == 0
//        } catch {
//            print(error)
//            return false
//        }
//    }
//}
//
//class TestProjectItem: TestData {
//    init(context: NSManagedObjectContext) {
//        super.init(context: context, entityName: "ProjectEntity")
//    }
//    
//    override func addItems() throws {
//        if super.noItemsExist() {
//            
//            for i in 1...2 {
//                let project = ProjectEntity(context: self.context)
//                if i % 2 == 0 {
//                    project.name = "Social Setting"
//                    project.creationDate = Date()
//                    project.systemIcon = "network"
//                } else {
//                    project.name = "Swift QR"
//                    project.creationDate = Date()
//                    project.systemIcon = "network"
//                }
//                
//                for j in 1...4 {
//                    let bodyParams1 = ParamEntity(context: self.context)
//                    if j % 2 == 0 {
//                        bodyParams1.key = "First_Name"
//                        bodyParams1.value = "Jonathan"
//                        bodyParams1.type = ParamType.Body.rawValue
//                    } else {
//                        bodyParams1.key = "First_Name"
//                        bodyParams1.value = "Jon"
//                        bodyParams1.type = ParamType.Body.rawValue
//                    }
//                    
//                    let bodyParams2 = ParamEntity(context: self.context)
//                    if j % 2 == 0 {
//                        bodyParams2.key = "Last_Name"
//                        bodyParams2.value = "Dowdell"
//                        bodyParams2.type = ParamType.Body.rawValue
//                    } else {
//                        bodyParams2.key = "Last_Name"
//                        bodyParams2.value = "Apollo"
//                        bodyParams2.type = ParamType.Body.rawValue
//                    }
//                    
//                    let request = RequestEntity(context: self.context)
//                    request.project = project
//                    if j % 2 == 0 {
//                        request.method = MethodType.GET.rawValue
//                        request.url = "https://www.google.com"
//                    } else {
//                        request.method = MethodType.POST.rawValue
//                        request.url = "https://www.twitter.com"
//                    }
//                    request.addToParams(bodyParams1)
//                    request.addToParams(bodyParams2)
//                    request.project = project
//                }
//            }
//            
//            try? context.save()
//        }
//    }
//}
