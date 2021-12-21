//
//  RequestEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//
//

import Foundation
import CoreData


extension RequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestEntity> {
        return NSFetchRequest<RequestEntity>(entityName: "RequestEntity")
    }

    @NSManaged public var method: String?
    @NSManaged public var url: String?
    @NSManaged public var project: ProjectEntity?
    @NSManaged public var urlParams: ParamEntity?
    @NSManaged public var headerParams: ParamEntity?
    @NSManaged public var bodyParams: ParamEntity?

}

extension RequestEntity : Identifiable {

}
