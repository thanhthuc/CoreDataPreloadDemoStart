//
//  District.swift
//  CoreDataPreloadDemo
//
//  Created by Thuc on 8/4/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

@objc(DistrictMO)
class DistrictMO: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var city_id: Int
    @NSManaged var name: String?
    @NSManaged var rank: String?
    @NSManaged var rank_order: String?
}
