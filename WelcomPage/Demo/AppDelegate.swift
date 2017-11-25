//
//  AppDelegate.swift
//  WelcomPage
//
//  Created by MoonCai on 2017/11/24.
//  Copyright © 2017年 Moon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()
        let welcomePage = WelcomeView(frame: UIScreen.main.bounds)
        welcomePage.imageNames = ["one",  "two", "three", "four"]
        welcomePage.welcomeClosure = {
            //点击立即开启动画放大透明化,并在动画结束移除欢迎页
            UIView.animate(withDuration: 2.0, animations: {
                welcomePage.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                welcomePage.alpha = 0
            }, completion: { (_) in
                welcomePage.removeFromSuperview()
            })
        }
        self.window?.addSubview(welcomePage)
        return true
    }

}

