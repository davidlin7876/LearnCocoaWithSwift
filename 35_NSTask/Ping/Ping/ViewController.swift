//
//  ViewController.swift
//  Ping
//
//  Created by Jason Zheng on 4/17/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  dynamic var domain = ""
  
  @IBOutlet weak var pingButton: NSButton!
  @IBOutlet var textView: NSTextView!
  
    let notificationCenter = NotificationCenter.default
  
    var task: Process?
    var fileHandle: FileHandle?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    domain = "toolinbox.net"
  }
  
  override func viewWillDisappear() {
    notificationCenter.removeObserver(self)
  }

  // MARK: - Action
  
  @IBAction func ping(_ sender: NSButton) {
    
    if sender.state == NSOnState {
        task = Process()
      task?.launchPath = "/sbin/ping"
      task?.arguments = ["-c4", domain]
      
        let pipe = Pipe()
      task?.standardOutput = pipe
      fileHandle = pipe.fileHandleForReading
      
      notificationCenter.removeObserver(self)
      notificationCenter.addObserver(self,
        selector: #selector(ViewController.receiveDataReadyNotification(_:)),
        name: FileHandle.readCompletionNotification, object: fileHandle)
      notificationCenter.addObserver(self,
        selector: #selector(ViewController.receiveTerminateNotification(_:)),
        name: Process.didTerminateNotification, object: task)
      
      task?.launch()
      
      clearString()
      fileHandle?.readInBackgroundAndNotify()
      
    } else {
      task?.interrupt()
      
      task = nil
      fileHandle = nil
    }
  }
  
  // MARK: - Notification
  
  func receiveDataReadyNotification(_ notification: NSNotification) {
    if let data = notification.userInfo?[NSFileHandleNotificationDataItem] as? NSData {
        if let string = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String? {
            appendString(string: string)
      }
    }
    
    // Continue to read if task is running (i.e., fileHandle isn't nil).
    fileHandle?.readInBackgroundAndNotify()
  }
  
  func receiveTerminateNotification(_ notification: NSNotification) {
    task = nil
    fileHandle = nil
    
    pingButton.state = NSOffState
  }
  
  // MARK: - Helper
  
  func clearString() {
    textView.string = ""
  }
  
  func appendString(string: String) {
    if let textStorage = textView.textStorage {
        textStorage.replaceCharacters(in: NSRange(location: textStorage.length, length: 0), with: string)
    }
  }
}

