//
//  ViewController.swift
//  LocalizationDemo
//
//  Created by Jason Zheng on 4/15/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  dynamic var question = ""  
  dynamic var answer = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setLabelStrings()
  }

    override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.)
    }
  }
  
  // MARK: - Helper
  
  func setLabelStrings() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    let dateString = dateFormatter.string(from: NSDate() as Date)
    
    question = NSLocalizedString("Q: What's the time now?", comment: "Question")
    answer = String(format: NSLocalizedString("A: It's %@.", comment: "Answer"), dateString)
  }
}

