//
//  AppDelegate.swift
//  Todoey
//
//  Created by Vikass s on 12/09/19.
//  Copyright © 2019 Chips PVT LTD. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(Realm.Configuration.defaultConfiguration.fileURL)
       
        
        do {
        _ = try Realm()
        } catch {
            print("Error initailizing the new realm \(error)")
        }
        
        
        
        return true
    }
  
    
}






