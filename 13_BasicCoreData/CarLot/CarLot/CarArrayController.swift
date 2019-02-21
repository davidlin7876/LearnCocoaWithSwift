//
//  CarArrayController.swift
//  CarLot
//
//  Created by Jason Zheng on 4/3/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController {
    override func newObject() -> Any {
        let object = super.newObject()
        (object as AnyObject).setValue("Car's name", forKey: "makeModel")
        (object as AnyObject).setValue(NSDate(), forKey: "datePurchased")
        (object as AnyObject).setValue(2, forKey: "condition")
        return object
    }
}

