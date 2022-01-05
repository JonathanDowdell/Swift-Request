//
//  ParamEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 1/5/22.
//
//

import Foundation
import CoreData


extension ParamEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParamEntity> {
        return NSFetchRequest<ParamEntity>(entityName: "ParamEntity")
    }

    @NSManaged public var active: Bool
    @NSManaged public var key: String?
    @NSManaged public var type: String?
    @NSManaged public var value: String?
    @NSManaged public var request: RequestEntity?

    var wrappedValue: String {
        value ?? ""
    }
    
    var wrappedKey: String {
        key ?? ""
    }
    
    var wrappedType: ParamType {
        return ParamType.init(type ?? "URL")
    }
}

extension ParamEntity : Identifiable {

}
