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
  
  @IBOutlet weak var arrayController: NSArrayController?

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
    employee.addObserver(self, forKeyPath: "name", options: .Old, context: &KVOContext)
    employee.addObserver(self, forKeyPath: "raise", options: .Old, context: &KVOContext)
  }
  
  func stopObservingEmployee(_ employee: Employee) {
    employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
    employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
      change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    
    guard context == &KVOContext else {
      // If the context does not match, this message must be intended for our superclass.
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      return
    }
    
    if let keyPath = keyPath, object = object, change = change {
      
      var oldValue = change[NSKeyValueChangeOldKey]
      if oldValue is NSNull {
        oldValue = nil
      }
      
      let undo = undoManager!
      // Note: here the target is object (i.e., the employee), but not self (the document)
      undo.prepareWithInvocationTarget(object).setValue(oldValue, forKeyPath: keyPath)
    }
  }
  
  // MARK: - Accessors
  
  // Undo for adding/removing employee
  
  // Bindings rely on KVO:
  //   objects bound to a key are automatically added as observers of that key
  //   and are then notified whenever its value changes.
  // Note: to be matched, the func and parameters names should be exactly as following.
  
  func insertObject(employee: Employee, inEmployeesAtIndex index: Int) {
    
    // Add inverse operation to undo stack
    let undo = undoManager!
    undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(employees.count)
    if !undo.undoing {
      undo.setActionName("Add Employee")
    }
    
    if index >= 0 && index <= employees.count {
      employees.insert(employee, atIndex: index)
      
    } else {
      employees.append(employee)
    }
  }
  
  func removeObjectFromEmployeesAtIndex(index: Int) {
    
    guard index >= 0 && index < employees.count else {
      return
    }
    
    let employee = employees[index]
    
    // Add inverse operation to undo stack
    let undo = undoManager!
    undo.prepareWithInvocationTarget(self).insertObject(employee, inEmployeesAtIndex: index)
    if !undo.undoing {
      undo.setActionName("Remove Employee")
    }
    
    employees.removeAtIndex(index)
  }
  
  // MARK: - Default
  
  override class func autosavesInPlace() -> Bool {
    return true
  }

  override var windowNibName: String? {
    return "Document"
  }

  override func dataOfType(typeName: String) throws -> NSData {
    return NSKeyedArchiver.archivedDataWithRootObject(employees)
  }

  override func readFromData(data: NSData, ofType typeName: String) throws {
    if let employeeArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Employee] {
      employees = employeeArray
    }
  }
  
  // MARK: - Actions
  
  @IBAction func removeEmployees(sender: NSButton) {
    
    let amount = arrayController?.selectedObjects.count ?? 0
    guard amount > 0 else {
      return
    }
    
    let alert = NSAlert()
    
    if amount == 1 {
      alert.messageText = "Are you sure to remove this employee?"
      let name = (arrayController?.selectedObjects[0] as? Employee)?.name ?? "This employee"
      alert.informativeText = "\(name) will be removed."
      
    } else {
      alert.messageText = "Are you sure to remove these employees?"
      alert.informativeText = "\(amount) employees will be removed."
    }
    
    alert.addButtonWithTitle("Remove")
    alert.addButtonWithTitle("Cancel")
    
//    let response = alert.runModal()
//    
//    switch response {
//    case NSAlertFirstButtonReturn:
//      if let employeesToRemove = arrayController?.selectedObjects as? [Employee] {
//        arrayController?.removeObjects(employeesToRemove)
//      }
//      
//    default:
//      break
//    }
    
    let window = sender.window
    
    alert.beginSheetModalForWindow(window!, completionHandler: {
      [unowned self] (response) -> Void in
      
      switch response {
      case NSAlertFirstButtonReturn:
        //        if let employeesToRemove = self.arrayController?.selectedObjects as? [Employee] {
        //          self.arrayController?.removeObjects(employeesToRemove)
        //        }

        // The array controller will delete the selected objects
        // The argument to remove() is ignored
        self.arrayController?.remove(nil)
        
      default:
        break
      }
    })
  }
  
  // MARK: - NSWindowDelegate
  
  override func windowControllerDidLoadNib(windowController: NSWindowController) {
    arrayController?.setSelectionIndex(-1)
  }
  
  func windowWillClose(notification: NSNotification) {
    // Note: need to remove observers before quit.
    employees = []
  }
}

