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
    @NSManaged public var raw_key: String?
    @NSManaged public var raw_type: String?
    @NSManaged public var raw_value: String?
    @NSManaged public var request: RequestEntity?

    var key: String {
        get {
            raw_key ?? ""
        } set {
            raw_key = newValue
        }
    }
    
    var value: String {
        get {
            raw_value ?? ""
        } set {
            raw_value = newValue
        }
    }
    
    var type: ParamType {
        get {
            ParamType.init(raw_type ?? "URL")
        } set {
            raw_type = newValue.rawValue
        }
    }
}

extension ParamEntity : Identifiable {

}
