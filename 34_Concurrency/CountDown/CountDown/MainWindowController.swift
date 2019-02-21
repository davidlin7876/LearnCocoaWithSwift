//
//  MainWindowController.swift
//  CountDown
//
//  Created by Jason Zheng on 6/2/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  dynamic var numString = "5"
  dynamic var isCountingDown = false
  
    private var countDownQueue = OperationQueue()
    private var countDownOperation: BlockOperation?
    var isCanceled = false
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  // MARK: - Action
  
  @IBAction func start(_ sender: NSButton!) {
    window?.makeFirstResponder(nil)
    if let num = Int(numString), num > 0 {
        startCountDown(num: num)
      isCountingDown = true
    }
  }
  
  @IBAction func stop(_ sender: NSButton!) {
    stopCountDown()
    isCountingDown = false
  }
  
  // MARK: - Helper
  
  func startCountDown(num: Int) {
    var num = num
    
    isCanceled = false
    DispatchQueue.global().async {
        [unowned self] in
        while num > 0 {
            sleep(1)
            if self.isCanceled {
                break;
            }
            num -= 1
            DispatchQueue.main.async {
                self.numString = "\(num)"
            }

            self.numString = "\(num)"
        }
        
        if num == 0 {
            DispatchQueue.main.async {
                self.isCountingDown = false
            }
        }
    }
//    countDownOperation = BlockOperation(block: {
//      while num > 0 {
//        sleep(1)
//
//        if self.countDownOperation!.isCancelled {
//          break
//        }
//
//        num -= 1
//        OperationQueue.main.addOperation({
//          self.numString = "\(num)"
//        })
//      }
//
//      if num == 0 {
//        OperationQueue.main.addOperation({
//          self.isCountingDown = false
//        })
//      }
//    })
//
//    countDownQueue.addOperation(countDownOperation!)
  }
  
  func stopCountDown() {
    isCanceled = true
//    countDownQueue.cancelAllOperations()
  }
}
