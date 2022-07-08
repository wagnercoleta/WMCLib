//
//  AppDelegate.swift
//  WMCLib
//
//  Created by wagnercoleta on 07/08/2022.
//  Copyright (c) 2022 wagnercoleta. All rights reserved.
//

import UIKit
import WMCLib

//MARK: Classes FAKE para testar DI
protocol ViewModelFakeProtocol { }
final class ViewModelFake {
    init() { }
}
extension ViewModelFake: ViewModelFakeProtocol { }

protocol ServiceFakeProtocol {}
final class ServiceFake {
    private let urlSession: URLSession
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
}
extension ServiceFake: ServiceFakeProtocol { }


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func registerDependency() {
        
        let serviceLocator: WMCServiceLocatorProtocol = WMCServiceLocator.shared
        
        //Registry ViewModelFake
        serviceLocator.register(instance: ViewModelFake.init(), forMetaType: ViewModelFakeProtocol.self)
        //Registry URLSession
        serviceLocator.register(instance: URLSession.shared, forMetaType: URLSession.self)
        //Registry ServiceFake
        serviceLocator.register(
            factory: { resolver in
                let session: URLSession = resolver.autoResolve()
                return ServiceFake(urlSession: session)
            },
            forMetaType: ServiceFakeProtocol.self
        )
        
        //Recup ViewModelFake
        let _: ViewModelFakeProtocol = serviceLocator.resolver(ViewModelFakeProtocol.self)
        //Recup ServiceFake
        let _: ServiceFakeProtocol = serviceLocator.autoResolve()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.registerDependency()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

