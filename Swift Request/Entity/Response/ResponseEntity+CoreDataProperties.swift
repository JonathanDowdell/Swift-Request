//
//  ResponseEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/7/22.
//
//

import Foundation
import CoreData


extension ResponseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResponseEntity> {
        return NSFetchRequest<ResponseEntity>(entityName: "ResponseEntity")
    }

    @NSManaged public var body: Data?
    @NSManaged public var raw_url: String?
    @NSManaged public var raw_creationDate: Date?
    @NSManaged public var statusCode: Int64
    @NSManaged public var request: RequestEntity?
    @NSManaged public var raw_headers: NSSet?
    @NSManaged public var responseTime: Int64

    var headers: [HeaderEntity] {
        let headers = raw_headers as? Set<HeaderEntity> ?? []
        return headers.map { $0 }
    }
    
    var creationDate: Date {
        get {
            raw_creationDate ?? Date()
        } set {
          raw_creationDate = newValue
        }
    }
    
    var url: String {
        get {
            raw_url ?? "No URL"
        } set {
            raw_url = newValue
        }
    }
    
    func addHeader(_ header: HeaderEntity) {
        self.addToRaw_headers(header)
    }
}

// MARK: Generated accessors for raw_headers
extension ResponseEntity {

    @objc(addRaw_headersObject:)
    @NSManaged public func addToRaw_headers(_ value: HeaderEntity)

    @objc(removeRaw_headersObject:)
    @NSManaged public func removeFromRaw_headers(_ value: HeaderEntity)

    @objc(addRaw_headers:)
    @NSManaged public func addToRaw_headers(_ values: NSSet)

    @objc(removeRaw_headers:)
    @NSManaged public func removeFromRaw_headers(_ values: NSSet)

}

extension ResponseEntity : Identifiable {

}
