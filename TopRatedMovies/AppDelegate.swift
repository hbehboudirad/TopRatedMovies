//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //create navigation controller with main view controller and apply theme to that
        let navigationController = UINavigationController()
        navigationController.viewControllers = [TopMoviesBuilder.build()]
        Styles.navigationBar(navigationController.navigationBar)
        
        //create window on screen
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //at target page as root page
        window?.rootViewController = navigationController
        
        //show the window
        window?.makeKeyAndVisible()
        
        return true
    }
}

