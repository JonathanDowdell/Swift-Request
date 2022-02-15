//
//  SettingEntity+CoreDataProperties.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/15/22.
//
//

import Foundation
import CoreData


extension SettingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingEntity> {
        return NSFetchRequest<SettingEntity>(entityName: "SettingEntity")
    }

    @NSManaged public var themeIndex: Int16
    @NSManaged public var tintIndex: Int16

}

extension SettingEntity : Identifiable {

}
