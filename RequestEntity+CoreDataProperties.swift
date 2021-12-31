//
//  RequestEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/23/21.
//
//

import Foundation
import CoreData


extension RequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestEntity> {
        return NSFetchRequest<RequestEntity>(entityName: "RequestEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var method: String?
    @NSManaged public var url: String?
    @NSManaged public var params: NSSet?
    @NSManaged public var project: ProjectEntity?
    @NSManaged public var creationDate: Date?
    @NSManaged public var contentType: String?
    @NSManaged public var order: Int64
    @NSManaged public var running: Bool
    

    var wrappedTitle: String {
        title ?? "Request"
    }
    
    var wrappedMethod: String {
        method ?? "GET"
    }
    
    var wrappedMethodType: MethodType {
        return MethodType.init(rawValue: method ?? "GET") ?? .GET
    }
    
    var wrappedURL: String {
        url ?? "Localhost"
    }
    
    var wrappedParams: [ParamEntity] {
        let params = params as? Set<ParamEntity> ?? []
        return params.map { $0 }
    }
    
    var wrappedContentType: BodyType {
        return BodyType.init(rawValue: contentType ?? "FormURLEncoded") ?? .FormURLEncoded
    }
    
    var wrappedCreationDate: Date {
        return self.creationDate ?? Date()
    }
    
}

// MARK: Generated accessors for params
extension RequestEntity {

    @objc(addParamsObject:)
    @NSManaged public func addToParams(_ value: ParamEntity)

    @objc(removeParamsObject:)
    @NSManaged public func removeFromParams(_ value: ParamEntity)

    @objc(addParams:)
    @NSManaged public func addToParams(_ values: NSSet)

    @objc(removeParams:)
    @NSManaged public func removeFromParams(_ values: NSSet)

}

extension RequestEntity : Identifiable {

}
