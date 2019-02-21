//
//  AppDelegate.swift
//  RGBWell
//
//  Created by Jason Zheng on 3/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var mainWindowController: MainWindowController?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainWindowController = MainWindowController.init(windowNibName: "MainWindowController")
    self.mainWindowController = mainWindowController
    mainWindowController.showWindow(self)
  }
}

