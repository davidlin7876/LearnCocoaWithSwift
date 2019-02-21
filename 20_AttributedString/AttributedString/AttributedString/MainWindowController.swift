//
//  MainWindowController.swift
//  AttributedString
//
//  Created by Jason Zheng on 5/5/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  @IBOutlet weak var button: NSButton!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    let attrString = NSMutableAttributedString(string: "Hello World!")
    
    attrString.addAttribute(NSFontAttributeName,
                            value: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize()),
                            range: NSRange(0...4))
    
    attrString.addAttribute(NSUnderlineStyleAttributeName,
                            value: NSUnderlineStyle.styleDouble.rawValue,
                            range: NSMakeRange(6, 5))
    
    attrString.addAttribute(NSForegroundColorAttributeName,
                            value: NSColor.orange,
                            range: NSRange(11...11))
    
    button.attributedTitle = attrString
  }
}
