//
//  RequestEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//
//

import Foundation
import CoreData


extension RequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestEntity> {
        return NSFetchRequest<RequestEntity>(entityName: "RequestEntity")
    }


}

extension RequestEntity : Identifiable {

}
