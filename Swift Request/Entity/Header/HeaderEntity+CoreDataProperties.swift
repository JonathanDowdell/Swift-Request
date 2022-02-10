//
//  HeaderEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/7/22.
//
//

import Foundation
import CoreData


extension HeaderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeaderEntity> {
        return NSFetchRequest<HeaderEntity>(entityName: "HeaderEntity")
    }

    @NSManaged public var response: ResponseEntity?

}
