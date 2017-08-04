//
//  AppDelegate.swift
//  CoreDataPreloadDemo
//
//  Created by Simon Ng on 13/5/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import FMDB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let path = applicationDocumentsDirectory.path
        print(path)
        
        // Check and copy db file to doccument
        Helper.copyFileToDocument(fileName: "address.db")
        
        // Read into core data
        let modelManager = ModelManager(fileName: "address.db")
        let cityTable = modelManager.getAllCityData() as! [City]
        let districtTalle = modelManager.getAllDistrictData() as! [District]
        let wardTable = modelManager.getAllWardData() as! [Ward]
        
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: "isPreloaded")
        
        let isPreloaded = userDefault.bool(forKey: "isPreloaded")
        userDefault.set(true, forKey: "isPreloaded")
        if !isPreloaded {
            preloadData(modelTable: cityTable)
            preloadData(modelTable: districtTalle)
            preloadData(modelTable: wardTable)
            userDefault.set(true, forKey: "isPreloaded")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.SFLink" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SFLink", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SFLink.sqlite")
        
        // Copy to path document if it not exist
        if !FileManager.default.fileExists(atPath: url.path) {
           
            let sourceUrls = [Bundle.main.url(forResource: "SFLink", withExtension: "sqlite"),
                             Bundle.main.url(forResource: "SFLink", withExtension: "sqlite-wal"),
                             Bundle.main.url(forResource: "SFLink", withExtension: "sqlite-shm")]
            let destUrls = [self.applicationDocumentsDirectory.appendingPathComponent("SFLink.sqlite"),
                           self.applicationDocumentsDirectory.appendingPathComponent("SFLink.sqlite-wal"),
                           self.applicationDocumentsDirectory.appendingPathComponent("SFLink.sqlite-shm")]
            
            for index in 0..<sourceUrls.count {
                do {
                    try FileManager.default.copyItem(at: sourceUrls[index]!, to: destUrls[index])
                } catch {
                    print(error)
                }
            }
        }
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
    func preloadData<T>(modelTable: T) {
        
        removeData(entity: modelTable)
        
        switch T.self {
            
        case is [City].Type:
            let citys = modelTable as! [City]
            for city in citys {
                let cityEntity = NSEntityDescription.insertNewObject(forEntityName: "CityMO", into: managedObjectContext) as! CityMO
                cityEntity.id = city.id!
                cityEntity.name = city.name
                cityEntity.rank = city.rank!
                cityEntity.rank_order = city.rankOrder
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
            
        case is [District].Type:
            let districts = modelTable as! [District]
            for district in districts {
                let districtEntity = NSEntityDescription.insertNewObject(forEntityName: "DistrictMO", into: managedObjectContext) as! DistrictMO
                districtEntity.id = district.id!
                districtEntity.city_id = district.cityId!
                districtEntity.name = district.name
                districtEntity.rank = district.rank!
                districtEntity.rank_order = district.rankOrder
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
            
        case is [Ward].Type:
            let wards = modelTable as! [Ward]
            for ward in wards {
                let wardEntity = NSEntityDescription.insertNewObject(forEntityName: "WardMO", into: managedObjectContext) as! WardMO
                wardEntity.id = ward.id!
                wardEntity.district_id = ward.districtId!
                wardEntity.name = ward.name
                wardEntity.rank = ward.rank!
                wardEntity.rank_order = ward.rankOrder
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        default:
            break
        }
    }
    
    func removeData <T>(entity: T) {
        
        switch T.self {
            
        case is [City].Type:
            // Remove the existing items
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityMO")
            
            do {
                let cityItems = try managedObjectContext.fetch(fetchRequest) as! [CityMO]
                for cityItem in cityItems {
                    managedObjectContext.delete(cityItem)
                }
            } catch {
                print(error)
            }
            
        case is [District].Type:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DistrictMO")
            do {
                let districtItems = try managedObjectContext.fetch(fetchRequest) as! [DistrictMO]
                for districtItem in districtItems {
                    managedObjectContext.delete(districtItem)
                }
            } catch {
                print(error)
            }
            
        case is [Ward].Type:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WardMO")
            do {
                let wardItems = try managedObjectContext.fetch(fetchRequest) as! [WardMO]
                for wardItem in wardItems {
                    managedObjectContext.delete(wardItem)
                }
            } catch {
                print(error)
            }
        default:
            break
        }
        
        
    }

}

