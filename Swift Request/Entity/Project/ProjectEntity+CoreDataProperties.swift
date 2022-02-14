//
//  ProjectEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/12/22.
//
//

import Foundation
import CoreData


extension ProjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity> {
        return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
    }

    @NSManaged public var raw_creation_date: Date?
    @NSManaged public var raw_name: String?
    @NSManaged public var order: Int32
    @NSManaged public var raw_system_icon: String?
    @NSManaged public var raw_version: String?
    @NSManaged public var raw_requests: NSSet?

    var name: String {
        get {
            raw_name ?? "Unnamed"
        } set {
            raw_name = newValue
        }
    }
    
    var systemIcon: String {
        get {
            raw_system_icon ?? "network"
        } set {
            raw_system_icon = newValue
        }
    }
    
    var version: String {
        get {
            raw_version ?? "Version 1.0"
        } set {
            raw_version = newValue
        }
    }
    
    var requests: [RequestEntity] {
        let requests = raw_requests as? Set<RequestEntity> ?? []
        return requests.map { $0 }
    }
    
    var orderedRequest: [RequestEntity] {
        let requestUnSorted = self.requests.allSatisfy { $0.order == 0 }
        return requests.sorted {
            if requestUnSorted {
                return $0.creationDate > $1.creationDate
            } else {
                return $0.order < $1.order
            }
        }
    }
    
    
    func addToRequests(_ value: RequestEntity) {
        self.addToRaw_requests(value)
    }
    
    func removeFromRequests(_ value: RequestEntity) {
        self.removeFromRaw_requests(value)
    }

}

// MARK: Generated accessors for raw_requests
extension ProjectEntity {

    @objc(addRaw_requestsObject:)
    @NSManaged public func addToRaw_requests(_ value: RequestEntity)

    @objc(removeRaw_requestsObject:)
    @NSManaged public func removeFromRaw_requests(_ value: RequestEntity)

    @objc(addRaw_requests:)
    @NSManaged public func addToRaw_requests(_ values: NSSet)

    @objc(removeRaw_requests:)
    @NSManaged public func removeFromRaw_requests(_ values: NSSet)

}

extension ProjectEntity : Identifiable {

}
