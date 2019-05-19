//
//  AppDelegate.swift
//  filmrausch
//
//  Created by Liridon Luzha on 16.12.18.
//  Copyright © 2018 Liridon Luzha. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        injectDependencies()
        return true
    }
    
    /// Injects the dependencies into the RootViewController
    private func injectDependencies() {
        
        if let rootVC = window?.rootViewController as? RootViewController {
            let filmrauschProvider = FilmrauschProvider()
            let imageProvider = ImageProvider()
            rootVC.movieFetchable = filmrauschProvider
            rootVC.imageFetchable = imageProvider
        }
    }
}

