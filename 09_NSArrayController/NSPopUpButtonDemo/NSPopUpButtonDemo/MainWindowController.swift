//
//  MainWindowController.swift
//  NSPopUpButtonDemo
//
//  Created by Jason Zheng on 4/20/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    @objc dynamic var personArray = [Person]()
    @objc dynamic var personSelected: Person? {
    didSet {
      if let person = personSelected {
        personDescription = "\(person.name) is \(person.age) years old."
      }
    }
  }
  @objc dynamic var personDescription = ""
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    personArray.append(Person(name: "Tom", age: 30))
    personArray.append(Person(name: "Jack", age: 29))
    personSelected = personArray[0]
  }
}
