//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Jason Zheng on 4/1/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController,
    NSSpeechSynthesizerDelegate, NSWindowDelegate,
    NSTableViewDataSource, NSTableViewDelegate {
  
  @IBOutlet weak var textField: NSTextField!
  @IBOutlet weak var speakButton: NSButton!
  @IBOutlet weak var stopButton: NSButton!
  
  @IBOutlet weak var tableView: NSTableView!
  
  private let preferenceManager = PreferenceManager()
  
  var isSpeaking = false {
    didSet {
      updateButtonStatus()
    }
  }
  
  let speaker = NSSpeechSynthesizer()
  let voices = NSSpeechSynthesizer.availableVoices()
  
  func updateButtonStatus() {
    if isSpeaking {
        speakButton.isEnabled = false
        stopButton.isEnabled = true
      
    } else {
        speakButton.isEnabled = true
        stopButton.isEnabled = false
    }
  }
  
  func getVoiceNameBy(idendifier: String) -> String? {
    
    let attritutes = NSSpeechSynthesizer.attributes(forVoice: idendifier)
    
    return attritutes[NSVoiceName] as? String
  }
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  func loadSpeakTextAndVoice() {
    textField.stringValue = preferenceManager.speakText ??
      preferenceManager.defaultSpeakText
    
    let voice = preferenceManager.speakVoice ??
      preferenceManager.defaultSpeakVoice
    
//    if let index = voices.indexOf(voice) {
    if let index = voices.firstIndex(of: voice){
      tableView.selectRowIndexes(NSIndexSet(index: index) as IndexSet,
                                 byExtendingSelection: false)
      tableView.scrollRowToVisible(index)
    }
  }
  
  // MARK: - NSWindowController
  
  override func windowDidLoad() {
    speaker.delegate = self
    
    updateButtonStatus()
    
    loadSpeakTextAndVoice()
  }
  
  // MARK: - Action
  
  @IBAction func speak(_ sender: NSButton) {
    let stringToBeSpoken = textField.stringValue
    
    if !stringToBeSpoken.isEmpty {
        speaker.startSpeaking(stringToBeSpoken)
      
      isSpeaking = true
    }
  }
  
  @IBAction func stop(_ sender: NSButton) {
    speaker.stopSpeaking()
  }
  
  @IBAction func reset(_ sender: NSButton) {
    preferenceManager.resetFactoryDefaults()
    
    loadSpeakTextAndVoice()
  }
  
  // MARK: - NSSpeechSynthesizerDelegate
  
  func speechSynthesizer(_ sender: NSSpeechSynthesizer,
                         didFinishSpeaking finishedSpeaking: Bool) {
    isSpeaking = false
  }
  
  // MARK: - NSWindowDelegate
  
  func windowShouldClose(sender: AnyObject) -> Bool {
    return !isSpeaking
  }
func windowWillClose(_ notification: Notification) {
    preferenceManager.speakText = textField.stringValue
    
    let row = tableView.selectedRow
    if row >= 0 && row < voices.count {
      preferenceManager.speakVoice = voices[row]
    } else {
      preferenceManager.speakVoice = preferenceManager.defaultSpeakVoice
    }
    
    // Write preference immediately as it's about to quit.
    preferenceManager.synchronize()
  }
  
  // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return voices.count
    }
  
func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    if row >= 0 && row < voices.count {
        return getVoiceNameBy(idendifier: voices[row]) as AnyObject
    }
    
    return nil
  }
  
  // MARK: - NSTableViewDelegate
func tableViewSelectionDidChange(_ notification: Notification) {
    let index = tableView.selectedRow
    
    if index == -1 {
      speaker.setVoice(nil)
      
    } else if index >= 0 && index < voices.count {
      speaker.setVoice(voices[index])
    }
  }
}
