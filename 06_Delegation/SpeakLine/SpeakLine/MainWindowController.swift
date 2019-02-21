//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Jason Zheng on 4/1/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController,
    NSSpeechSynthesizerDelegate, NSWindowDelegate {
  
  @IBOutlet weak var textField: NSTextField!
  @IBOutlet weak var speakButton: NSButton!
  @IBOutlet weak var stopButton: NSButton!
  
  var isSpeaking = false {
    didSet {
      updateButtonStatus()
    }
  }
  
  let speaker = NSSpeechSynthesizer()
  
  func updateButtonStatus() {
    if isSpeaking {
        speakButton.isEnabled = false
        stopButton.isEnabled = true
      
    } else {
        speakButton.isEnabled = true
        stopButton.isEnabled = false
    }
  }
  
  // MARK: - NSWindowController
  
  override var windowNibName: String? {
    return "MainWindowController"
  }

  override func windowDidLoad() {
    updateButtonStatus()
    
    speaker.delegate = self
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
  
  // MARK: - NSSpeechSynthesizerDelegate
  
  func speechSynthesizer(_ sender: NSSpeechSynthesizer,
                         didFinishSpeaking finishedSpeaking: Bool) {
    isSpeaking = false
  }
  
  // MARK: - NSWindowDelegate
  
    private func windowShouldClose(_ sender: AnyObject) -> Bool {
        return !isSpeaking
  }
}
