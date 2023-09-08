//
//  DiaryContents+CoreDataProperties.swift
//  
//
//  Created by Minseong Kang on 2023/09/08.
//
//

import Foundation
import CoreData


extension DiaryContents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryContents> {
        return NSFetchRequest<DiaryContents>(entityName: "DiaryContents")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: NSDecimalNumber?
    @NSManaged public var title: String?

}
