//
//  AppDelegate.swift
//  TorrentStream
//
//  Created by Chan Fai Chong on 18/2/2016.
//  Copyright © 2016 Ignition Soft. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        DefaultTorrentService.instance.getState()
            .subscribeNext { (state) -> Void in
                switch state.status {
                case .Init:
                    print("Loading")
                case .Idle:
                    print("READY")
                    let search = DefaultTorrentService
                        .instance
                        .search("GATE", engine: .DMHY)
                        .shareReplay(1)
                        
                    search.subscribeError({ (errno) -> Void in
                            print("errno: \(errno)")
                        })
                        .addDisposableTo(self.disposeBag)

                    search.subscribeNext({ (result) -> Void in
                            print("result: \(result)")
                        })
                        .addDisposableTo(self.disposeBag)
                case .LoadingMetadata:
                    print("LoadingMetadata")
                case .Listening:
                    print("Stream Server Listening")
                case .Finished:
                    print("Finished Streaming")
                }
            }
            .addDisposableTo(self.disposeBag)
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

