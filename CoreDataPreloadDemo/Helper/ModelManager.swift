//
//  ModelManager.swift
//  CoreDataPreloadDemo
//
//  Created by Thuc on 8/4/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import FMDB



class ModelManager {
    
    static var fileName: String?
    var database: FMDatabase?
    
    init(fileName: String) {
        if database == nil {
            database = FMDatabase(path: Helper.pathForDocument(fileName: fileName))
        }
    }
    
    func getAllDistrictData() -> NSMutableArray {
        
        database!.open()
        let resultSet: FMResultSet! = database!.executeQuery("SELECT * FROM district", withArgumentsIn: [])
        let mArrDistrictInfo : NSMutableArray = NSMutableArray()
        
        if (resultSet != nil) {
            while resultSet.next() {
                let district = District()
                district.id = Int(resultSet.string(forColumn: "id")!)
                district.cityId = Int(resultSet.string(forColumn: "city_id")!)
                district.name = resultSet.string(forColumn: "name")
                district.rank = resultSet.string(forColumn: "rank")
                district.rankOrder = resultSet.string(forColumn: "rank_order")
                mArrDistrictInfo.add(district)
            }
        }
        database!.close()
        
        return mArrDistrictInfo
    }
    
    func getAllWardData() -> NSMutableArray {
        database!.open()
        let resultSet: FMResultSet! = database!.executeQuery("SELECT * FROM ward", withArgumentsIn: [])
        let mArrWardInfo = NSMutableArray()
        
        if (resultSet != nil) {
            while resultSet.next() {
                let ward = Ward()
                ward.id = Int(resultSet.string(forColumn: "id")!)
                ward.districtId = Int(resultSet.string(forColumn: "district_id")!)
                ward.name = resultSet.string(forColumn: "name")
                ward.rank = resultSet.string(forColumn: "rank")
                ward.rankOrder = resultSet.string(forColumn: "rank_order")
                mArrWardInfo.add(ward)
            }
        }
        database!.close()
        return mArrWardInfo
    }
    
    func getAllCityData() -> NSMutableArray {
        database!.open()
        let resultSet: FMResultSet! = database!.executeQuery("SELECT * FROM city", withArgumentsIn: [])
        let mArrCityInfo = NSMutableArray()
        
        if (resultSet != nil) {
            while resultSet.next() {
                let city = City()
                city.id = Int(resultSet.string(forColumn: "id")!)
                city.name = resultSet.string(forColumn: "name")
                city.rank = resultSet.string(forColumn: "rank")
                city.rankOrder = resultSet.string(forColumn: "rank_order")
                mArrCityInfo.add(city)
            }
        }
        database!.close()
        
        return mArrCityInfo
    }
    
    
    
}
