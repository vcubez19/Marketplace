//
//  Search+CoreDataProperties.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var searchText: String?
    @NSManaged public var created: Date?

}

extension Search : Identifiable {

}
