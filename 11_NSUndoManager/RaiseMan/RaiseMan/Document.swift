//
//  Document.swift
//  RaiseMan
//
//  Created by Jason Zheng on 4/2/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

// Used to get a unique value to use as the KVO context pointer.
private var KVOContext = 0

class Document: NSDocument {
  
  var employees = [Employee]() {
    willSet {
      for employee in employees {
        stopObservingEmployee(employee)
      }
    }
    
    didSet {
      for employee in employees {
        startObservingEmployee(employee)
      }
    }
  }

  override init() {
    super.init()
    
    employees.append(Employee(name: "Tom", raise: 0.05))
    employees.append(Employee(name: "jack", raise: 0.1))
    employees.append(Employee(name: "Jack", raise: 0.15))
    employees.append(Employee(name: "Jacky", raise: 0.1))
    
    // Note: initialize employees will not call willSet/didSet,
    //       thus need to manually add observer.
    for employee in employees {
      startObservingEmployee(employee)
    }
  }
  
  // MARK: - Key Value Observing
  
  func startObservingEmployee(_ employee: Employee) {
    employee.addObserver(self, forKeyPath: "name", options: .old, context: &KVOContext)
    employee.addObserver(self, forKeyPath: "raise", options: .old, context: &KVOContext)
  }
  
  func stopObservingEmployee(_ employee: Employee) {
    employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
    employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
  }
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    guard context == &KVOContext else {
      // If the context does not match, this message must be intended for our superclass.
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      return
    }
    
        if let keyPath = keyPath, let object = object, let change = change {
      
            var oldValue = change[NSKeyValueChangeKey.oldKey]
      if oldValue is NSNull {
        oldValue = nil
      }
      
      let undo = undoManager!
      // Note: here the target is object (i.e., the employee), but not self (the document)
            (undo.prepare(withInvocationTarget: object) as? Employee)?.setValue(oldValue, forKeyPath: keyPath)
//      undo.prepareWithInvocationTarget(object).setValue(oldValue, forKeyPath: keyPath)
    }
  }
  
  // MARK: - Accessors
  
  // Undo for adding/removing employee
  
  // Bindings rely on KVO:
  //   objects bound to a key are automatically added as observers of that key
  //   and are then notified whenever its value changes.
  // Note: to be matched, the func and parameters names should be exactly as following.
  
  func insertObject(_ employee: Employee, inEmployeesAtIndex index: Int) {
    
    // Add inverse operation to undo stack
    let undo = undoManager!
    (undo.prepare(withInvocationTarget: self) as? Document)?.removeObjectFromEmployeesAtIndex(employees.count)
//    undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(employees.count)
    if !undo.isUndoing {
      undo.setActionName("Add Employee")
    }
    
    if index >= 0 && index <= employees.count {
        employees.insert(employee, at: index)
      
    } else {
      employees.append(employee)
    }
  }
  
  func removeObjectFromEmployeesAtIndex(_ index: Int) {
    
    guard index >= 0 && index < employees.count else {
      return
    }
    
    let employee = employees[index]
    
    // Add inverse operation to undo stack
    let undo = undoManager!
//    undo.prepareWithInvocationTarget(self).insertObject(employee, inEmployeesAtIndex: index)
    (undo.prepare(withInvocationTarget: self) as? Document)?.insertObject(employee, inEmployeesAtIndex: index)
    if !undo.isUndoing {
      undo.setActionName("Remove Employee")
    }
    
    employees.remove(at: index)
  }
  
  // MARK: - Default
  
  override class func autosavesInPlace() -> Bool {
    return false
  }

  override var windowNibName: String? {
    return "Document"
  }

    override func data(ofType typeName: String) throws -> Data {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    override func read(from data: Data, ofType typeName: String) throws {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
  
  // MARK: - NSWindowDelegate
  
  func windowWillClose(notification: NSNotification) {
    // Note: need to remove observers before quit.
    employees = []
  }
}

