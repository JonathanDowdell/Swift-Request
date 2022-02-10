//
//  RequestEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/7/22.
//
//

import Foundation
import CoreData


extension RequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestEntity> {
        return NSFetchRequest<RequestEntity>(entityName: "RequestEntity")
    }

    @NSManaged public var raw_contentType: String?
    @NSManaged public var raw_creationDate: Date?
    @NSManaged public var raw_method: String?
    @NSManaged public var order: Int64
    @NSManaged public var running: Bool
    @NSManaged public var raw_title: String?
    @NSManaged public var raw_url: String?
    @NSManaged public var raw_params: NSSet?
    @NSManaged public var project: ProjectEntity?
    @NSManaged public var raw_responses: NSSet?
    
    var title: String {
        get {
            raw_title ?? "Request"
        } set {
            raw_title = newValue
        }
    }
    
    var method: String {
        get {
            raw_method ?? "GET"
        } set {
            raw_method = newValue
        }
    }
    
    var methodType: MethodType {
        MethodType.init(rawValue: raw_method ?? "GET") ?? .GET
    }
    
    var url: String {
        get {
            raw_url ?? "Localhost"
        } set {
            raw_url = newValue
        }
    }
    
    var params: [ParamEntity] {
        let params = raw_params as? Set<ParamEntity> ?? []
        return params.map { $0 }
    }
    
    var contentType: BodyType {
        get {
            BodyType.init(rawValue: raw_contentType ?? "FormURLEncoded") ?? .FormURLEncoded
        } set {
            raw_contentType = newValue.rawValue
        }
    }
    
    var creationDate: Date {
        get {
            self.raw_creationDate ?? Date()
        } set {
            self.raw_creationDate = newValue
        }
    }
    
    var responses: [ResponseEntity] {
        let response = raw_responses as? Set<ResponseEntity> ?? []
        return response.map { $0 }
    }
    
    func addResponses(_ responseHistory: ResponseEntity) {
        self.addToRaw_responses(responseHistory)
    }

}

// MARK: Generated accessors for raw_params
extension RequestEntity {

    @objc(addRaw_paramsObject:)
    @NSManaged public func addToRaw_params(_ value: ParamEntity)

    @objc(removeRaw_paramsObject:)
    @NSManaged public func removeFromRaw_params(_ value: ParamEntity)

    @objc(addRaw_params:)
    @NSManaged public func addToRaw_params(_ values: NSSet)

    @objc(removeRaw_params:)
    @NSManaged public func removeFromRaw_params(_ values: NSSet)

}

// MARK: Generated accessors for raw_responses
extension RequestEntity {

    @objc(addRaw_responsesObject:)
    @NSManaged public func addToRaw_responses(_ value: ResponseEntity)

    @objc(removeRaw_responsesObject:)
    @NSManaged public func removeFromRaw_responses(_ value: ResponseEntity)

    @objc(addRaw_responses:)
    @NSManaged public func addToRaw_responses(_ values: NSSet)

    @objc(removeRaw_responses:)
    @NSManaged public func removeFromRaw_responses(_ values: NSSet)

}

extension RequestEntity : Identifiable {

}
