//
//  Document.swift
//  RaiseMan
//
//  Created by Jason Zheng on 4/2/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var employees = [Employee]()
    override init() {
        super.init()

        employees.append(Employee(name: "Tom", raise: 0.05))
        employees.append(Employee(name: "jack", raise: 0.1))
        employees.append(Employee(name: "Jack", raise: 0.15))
        employees.append(Employee(name: "Jacky", raise: 0.1))
    }
    override class func autosavesInPlace() -> Bool {
        return true
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
}

