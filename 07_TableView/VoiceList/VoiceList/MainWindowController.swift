//
//  MainWindowController.swift
//  VoiceList
//
//  Created by Jason Zheng on 4/1/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate,
    NSTableViewDataSource, NSTableViewDelegate {
  
  @IBOutlet weak var voiceLabel: NSTextField!
  @IBOutlet weak var voiceTableView: NSTableView!
  
  let emptyVoiceLabelName = "None"
  
  let voices = NSSpeechSynthesizer.availableVoices()
  
  func getVoiceNameBy(_ identifier: String) -> String? {
    let attributes = NSSpeechSynthesizer.attributes(forVoice: identifier)
    
    return attributes[NSVoiceName] as? String
  }
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
    
// MARK: - NSWindowDelegate
  
  override func windowDidLoad() {
    let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        if let index = voices.firstIndex(of: defaultVoice){
        voiceTableView.selectRowIndexes(NSIndexSet(index: index) as IndexSet,
                                      byExtendingSelection: false)
      voiceTableView.scrollRowToVisible(index)
    }
  }
  
  // MARK: - NSTableViewDataSource
  func numberOfRows(in tableView: NSTableView) -> Int {
    return voices.count
  }
  
  func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    if row >= 0 && row < voices.count {
        return getVoiceNameBy(voices[row]) as AnyObject
    }

    return nil
    }
  
  // MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = voiceTableView.selectedRow
        if index >= 0 && index < voices.count {
          voiceLabel.stringValue = getVoiceNameBy(voices[index]) ?? emptyVoiceLabelName
        } else {
          voiceLabel.stringValue = emptyVoiceLabelName
        }
    }
}
