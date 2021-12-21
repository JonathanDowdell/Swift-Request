//
//  QueryParamEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/20/21.
//
//

import Foundation
import CoreData


extension QueryParamEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QueryParamEntity> {
        return NSFetchRequest<QueryParamEntity>(entityName: "QueryParamEntity")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?
    @NSManaged public var active: Bool
    
    var wrappedKey: String {
        return key ?? ""
    }
    
    var wrappedValue: String {
        return value ?? ""
    }

}

extension QueryParamEntity : Identifiable {

}
