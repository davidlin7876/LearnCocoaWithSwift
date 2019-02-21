//
//  GeneratePassword.swift
//  GeneratePassword
//
//  Created by Jason Zheng on 3/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

private let characters = ("0123456789"
    + "abcdefghijklmnopqrstuvwxyz"
    + "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

private func generateRandomCharacter() -> Character {
    let index = Int(arc4random_uniform(UInt32(characters.count)))
    
//    return characters[characters.startIndex.advancedBy(index)]
    return characters[characters.index(characters.startIndex, offsetBy: index)]
}

func generateRandomString(_ length: Int) -> String {
    var password = ""
    
    for _ in 0..<length {
        password.append(generateRandomCharacter())
    }
    
    return password
}
