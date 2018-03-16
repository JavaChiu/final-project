//
//  AppDelegate.swift
//  final-project-mock-up
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var launchFromTerminated = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.launchFromTerminated = true
        registerSettingsBundle()
        
        // Firebase setup
        FirebaseApp.configure()
        
        // Facebook setup
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // NewPostViewController modal presentation
        if viewController.restorationIdentifier == "NewPostNavigationController" {
            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "NewPostNavigationController") as? UINavigationController {
                newVC.modalPresentationStyle = .overFullScreen
                tabBarController.present(newVC, animated: true)
            }
            return false
        }
        return true
    }

    // MARK: Lifecycle
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if launchFromTerminated == false {
            showSplashScreen(autoDismiss: false)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if launchFromTerminated {
            showSplashScreen(autoDismiss: false)
            launchFromTerminated = false
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: private functions
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
        
        if let firstLaunch = UserDefaults.standard.string(forKey: "first_launch") {
            print(firstLaunch)
        } else {
            UserDefaults.standard.setValue(Date().dateString(), forKey: "first_launch")
        }
    }

}

extension AppDelegate {
    
    /// Load the SplashViewController from Splash.storyboard
    func showSplashScreen(autoDismiss: Bool) {
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        // Control the behavior from suspended to launch
        controller.autoDismiss = autoDismiss
        
        // Present the view controller over the top view controller
        let vc = topController()
        vc.present(controller, animated: false, completion: nil)
    }
    
    
    /// Determine the top view controller on the screen
    /// - Returns: UIViewController
    func topController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            return topController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}


