//
//  ProjectEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
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
    @NSManaged public var requests: NSSet?

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
