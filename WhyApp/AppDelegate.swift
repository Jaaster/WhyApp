//
//  AppDelegate.swift
//  WhyApp
//
//  Created by Joriah Lasater on 5/31/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let goalVC = UINavigationController(rootViewController: GoalsUIViewController())
        window?.rootViewController = goalVC
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CDPersistenceService.saveContext()
    }
}
