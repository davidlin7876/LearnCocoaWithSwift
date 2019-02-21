//
//  MainWindowController.swift
//  Thermostat
//
//  Created by Jason Zheng on 4/1/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  // Solution 3: use dynamic
  //dynamic var templature = 37
  var templature = 37
  
  private var privateIsOn = true
  var isOn: Bool {
    get {
      return privateIsOn
    }
    
    set {
      privateIsOn = newValue
    }
  }
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  @IBAction func changeWarmer(_ sender: NSButton) {
    
    // Solution 1: Use KVC(Key-value coding)
    setValue(templature + 1, forKey: "templature")
  }
  
  @IBAction func changeCooler(_ sender: NSButton) {
    
    // Solution 2: Use KVO(Key-value observing)
    willChangeValue(forKey: "templature")
    
    templature -= 1
    
    didChangeValue(forKey: "templature")
  }
}
