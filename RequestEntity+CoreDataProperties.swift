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

    var wrappedTitle: String {
        title ?? "Request"
    }
    
    var wrappedMethod: String {
        method ?? "GET"
    }
    
    var wrappedURL: String {
        url ?? "Localhost"
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
