//
//  TodoAmbiguo+CoreDataProperties.swift
//  prueba-doonamis
//
//  Created by Eric Melé Lorite on 6/7/23.
//
//

import Foundation
import CoreData


extension TodoAmbiguo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoAmbiguo> {
        return NSFetchRequest<TodoAmbiguo>(entityName: "TodoAmbiguo")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var popularity: Float
    @NSManaged public var overview: String?
    @NSManaged public var vote_count: Int32
    @NSManaged public var vote_average: Float
    @NSManaged public var poster_path: String?
    @NSManaged public var genre_ids: NSObject?

}

extension TodoAmbiguo : Identifiable {

}
