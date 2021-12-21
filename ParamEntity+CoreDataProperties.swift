//
//  ParamEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
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

    var wrappedValue: String {
        value ?? ""
    }
    
    var wrappedKey: String {
        key ?? ""
    }
}

extension ParamEntity : Identifiable {

}
