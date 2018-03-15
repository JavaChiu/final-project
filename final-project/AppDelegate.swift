//
//  AppDelegate.swift
//  final-project-mock-up
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var launchFromTerminated = false
    
    // MARK: Facebook SDK
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.launchFromTerminated = true
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // NewPostViewController modal presentation
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
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


