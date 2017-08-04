//
//  Helper.swift
//  CoreDataPreloadDemo
//
//  Created by Thuc on 8/4/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    class func pathForDocument(fileName: String) -> String? {
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrlString = documentURL.appendingPathComponent(fileName)
        
        return fileUrlString.path
    }
    
    class func copyFileToDocument(fileName: NSString) {
        
        let path = Helper.pathForDocument(fileName: fileName as String)
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path!) {
            
            let pathForBundle = Bundle.main.resourceURL
            let fromPath = pathForBundle?.appendingPathComponent(fileName as String)
            
            print("Bundle path: \(fromPath!)")

            do {
                try fileManager.copyItem(atPath: fromPath!.path, toPath: path!)
            } catch {
                print(error)
            }
        }
    }
}


