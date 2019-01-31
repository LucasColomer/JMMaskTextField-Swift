//
//  JMStringMask.swift
//  JMMaskTextField Swift
//
//  Created by Jota Melo on 02/01/17.
//  Copyright © 2017 Jota. All rights reserved.
//

import Foundation

fileprivate struct Constants {
    static let numberMaskCharacter: Character = "0"
}

public struct JMStringMask: Equatable {
    
    var mask: String = ""
    
    private init() { }
    
    public init(mask: String) {
        self.init()
        
        self.mask = mask
    }
    
    public static func ==(lhs: JMStringMask, rhs: JMStringMask) -> Bool {
        return lhs.mask == rhs.mask
    }
    
    public func mask(string: String?) -> String? {
        
        guard let string = string else { return nil }
        
        if string.count > self.mask.count {
            return nil
        }
        
        var formattedString = ""
        
        var currentMaskIndex = 0
        for i in 0..<string.count {
            if currentMaskIndex >= self.mask.count {
                return nil
            }
            
            let currentCharacter = string[string.index(string.startIndex, offsetBy: i)]
            var maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
            
            if currentCharacter == maskCharacter {
                formattedString.append(currentCharacter)
            } else {
                while (maskCharacter != Constants.numberMaskCharacter) {
                    formattedString.append(maskCharacter)
                    
                    currentMaskIndex += 1
                    maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
                }
                
                let isValidNumber = maskCharacter == Constants.numberMaskCharacter && self.isValidNumberCharacter(currentCharacter)
                
                if !isValidNumber {
                    return nil
                }
                
                formattedString.append(currentCharacter)
            }
            
            currentMaskIndex += 1
        }
        
        return formattedString
    }
    
    public func unmask(string: String?) -> String? {
        
        guard let string = string else { return nil }
        var unmaskedValue = ""
        
        for character in string {
            if self.isValidNumberCharacter(character) {
                unmaskedValue.append(character)
            }
        }
        
        return unmaskedValue
    }
    
    private func isValidNumberCharacter(_ character: Character) -> Bool {
        
        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }
        
        let numberSet = NSCharacterSet.decimalDigits
        let numberUnicodeScalars = string.unicodeScalars
        let lettersSet = NSCharacterSet.letters
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex]) || numberSet.contains(numberUnicodeScalars[numberUnicodeScalars.startIndex])
    }
    
}
