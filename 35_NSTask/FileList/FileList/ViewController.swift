//
//  ViewController.swift
//  FileList
//
//  Created by Jason Zheng on 4/17/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet var textView: NSTextView!
  
  // MARK: - Action
  
  @IBAction func openFolder(_ sender: NSButton) {
    let defaultFolderURL: URL
    do {
        defaultFolderURL = try FileManager.default.url(
            for: FileManager.SearchPathDirectory.downloadsDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask,
            appropriateFor: nil, create: false)
      
    } catch {
      defaultFolderURL = URL(fileURLWithPath: "~/Downloads")
    }
    
    let openPanel = NSOpenPanel()
    openPanel.directoryURL = defaultFolderURL
    openPanel.canChooseDirectories = true
    openPanel.canChooseFiles = false
    openPanel.prompt = "Open"
    
    let selection:NSApplication.ModalResponse = openPanel.runModal()
    if  selection == NSModalResponseOK {
        if let path = openPanel.url?.path {
            if let content = getFileListOf(path: path) {
          if let textStorage = textView.textStorage {
            textStorage.replaceCharacters(in: NSRange(0..<textStorage.length), with: content)
          }
        }
      }
    }
  }
  
  // MARK: - Helper
  
  func getFileListOf(path: String) -> String? {
    let task = Process()
    task.launchPath = "/bin/ls"
    task.arguments = ["-l", path]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    
    task.launch()
    task.waitUntilExit()
    
    let fileHandler = pipe.fileHandleForReading
    let data = fileHandler.readDataToEndOfFile()
    
    if task.terminationStatus != 0 {
      NSLog("Failed to open file list. Reason: \(task.terminationReason)")
      return nil
    }
    
    return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
  }
}

