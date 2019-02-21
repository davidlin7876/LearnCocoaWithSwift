//
//  MainWindowController.swift
//  RanchForecast
//
//  Created by Jason Zheng on 6/1/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  let fetcher = ScheduleFetcher()
  dynamic var courses = [Course]()
  
  @IBOutlet weak var courseView: NSScrollView!
  @IBOutlet weak var tableView: NSTableView!
  @IBOutlet weak var arrayController: NSArrayController!
  @IBOutlet weak var waitingIndicator: NSProgressIndicator!
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    courseView.isHidden = true
    waitingIndicator.startAnimation(self)
    
    fetcher.fetchCourses { (fetchCourseResult) in
      switch fetchCourseResult {
      case .Succeed(let courses):
        self.courses = courses
      case .Failed(let error):
        self.courses = []
        print("Get error: \(error)")
      }
      self.courseView.isHidden = false
      self.waitingIndicator.stopAnimation(self)
      self.waitingIndicator.isHidden = true
    }
    
    tableView.target = self
    tableView.doubleAction = #selector(MainWindowController.openCourse(_:))
  }
  
  func openCourse(_ sender: AnyObject!) {
    if let course = arrayController.selectedObjects.first as? Course {
        NSWorkspace.shared().open(course.url as URL)
    }
  }
}
