//
//  PreferenceManager.swift
//  SpeakLine
//
//  Created by Jason Zheng on 4/4/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class PreferenceManager {
    let userDefaults = UserDefaults.standard
  
  private let speakTextKey = "Speak Text"
  private let speakVoiceKey = "Speak Voice"
  
  let defaultSpeakText = ""
  let defaultSpeakVoice = NSSpeechSynthesizer.defaultVoice()
  
  var speakText: String {
    get {
        return (userDefaults.object(forKey: speakTextKey) as? String) ?? defaultSpeakText
    }
    
    set {
        userDefaults.set(newValue, forKey: speakTextKey)
    }
  }
  
  var speakVoice: String {
    get {
//        return (userDefaults.object(forKey: speakTextKey) as? String) ?? defaultSpeakTextspeakVoiceKey) as? String) ?? defaultSpeakVoice
        return userDefaults.object(forKey: speakTextKey) as! String
    }
    
    set {
        userDefaults.set(newValue, forKey: speakVoiceKey)
    }
  }
  
  init() {
    registerFactoryDefaults()
  }
  
  func registerFactoryDefaults() {
    let factoryDefaults = [
      speakTextKey: defaultSpeakText,
      speakVoiceKey: defaultSpeakVoice
    ]
    
    userDefaults.register(defaults: factoryDefaults)
  }
  
  func resetFactoryDefaults() {
    userDefaults.removeObject(forKey: speakTextKey)
    userDefaults.removeObject(forKey: speakVoiceKey)
  }
  
  func synchronize() {
    userDefaults.synchronize()
  }
}
