//
//  AppDelegate.swift
//  TextileDemo
//
//  Created by Max Rozdobudko on 27.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import Textile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initTextile()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: - Textile init

extension AppDelegate {

    fileprivate func initTextile() {
        print(Textile.instance())
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let repoPath = (documentPath as NSString).appendingPathComponent("textile-repo")

        if !Textile.isInitialized(repoPath) {
            var error: NSError?
            Textile.initializeCreatingNewWalletAndAccount(repoPath, debug: true, logToDisk: true, error: &error)
        }

        do {
            try Textile.launch(repoPath, debug: true)
        } catch let e {
            print(e.localizedDescription)
        }

        var error: NSError?

        print("seed > \(Textile.instance().account.seed())")
        print("account > \(Textile.instance().account.contact(&error))")

        Textile.instance().delegate = self

        print(Textile.instance())
    }

    fileprivate func connectToCafe() {
        Textile.instance().cafes.register("https://8bc36ced.ngrok.io", token: "2GHPKw5TBbZYFHUkpUbKWMDYGpaBntYacj9JcCg5yXGcNTZ7sGBEZvkgCk9kz") { error in
//            print(error)
        }
        var error: NSError?
        let sessions = Textile.instance().cafes.sessions(&error)
        if let error = error {
            print("ERROR \(error.localizedDescription)")
        } else {
            print("sessions: \(sessions)")
        }
    }

}


// MARK: - TextileDelegate

extension AppDelegate: TextileDelegate {

    func threadUpdateReceived(_ threadId: String, data feedItemData: FeedItemData) {
        print("threadUpdateReceived \(threadId)")
    }

    func nodeOnline() {
        print("nodeOnline")
        connectToCafe()
    }
}
