//
//  AppDelegate.swift
//  Todoey
//
//  Created by murad on 19.12.2024.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configureRealm()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Realm
    
    private func configureRealm() {
        
        
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 4 {
                    // Автоматическая миграция для нового свойства `date`
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
    }

}

