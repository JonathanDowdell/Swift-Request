//
//  ProjectEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 1/5/22.
//
//

import Foundation
import CoreData


extension ProjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity> {
        return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var order: Int32
    @NSManaged public var systemIcon: String?
    @NSManaged public var version: String?
    @NSManaged public var requests: NSSet?

    var wrappedName: String {
        name ?? "Unnamed"
    }
    
    var wrappedSystemIcon: String {
        systemIcon ?? "network"
    }
    
    var wrappedVersion: String {
        version ?? "Version 1.0"
    }
    
    var wrappedRequests: [RequestEntity] {
        let requests = requests as? Set<RequestEntity> ?? []
        return requests.map { $0 }
    }
}

// MARK: Generated accessors for requests
extension ProjectEntity {

    @objc(addRequestsObject:)
    @NSManaged public func addToRequests(_ value: RequestEntity)

    @objc(removeRequestsObject:)
    @NSManaged public func removeFromRequests(_ value: RequestEntity)

    @objc(addRequests:)
    @NSManaged public func addToRequests(_ values: NSSet)

    @objc(removeRequests:)
    @NSManaged public func removeFromRequests(_ values: NSSet)

}

extension ProjectEntity : Identifiable {

}
