//
//  AppDelegate.swift
//  RaiseMan
//
//  Created by Jason Zheng on 4/2/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    for window in NSApp.windows {
      if let contentView = window.contentView {
        window.visualizeConstraints(contentView.constraints)
      }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

