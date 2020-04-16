//
//  UserDataService.swift
//  Smack
//
//  Created by Chris Mercer on 15/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColour = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColour = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func getUIColor(components: String) -> UIColor {
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = ","
        scanner.charactersToBeSkipped = skipped
    
        var r, g, b, a : String?
        r = scanner.scanUpToString(comma)
        g = scanner.scanUpToString(comma)
        b = scanner.scanUpToString(comma)
        a = scanner.scanUpToString(comma)

        let defaultColour = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColour}
        guard let gUnwrapped = g else { return defaultColour}
        guard let bUnwrapped = b else { return defaultColour}
        guard let aUnwrapped = a else { return defaultColour}
        
        let rFloat = CGFloat(Double(rUnwrapped)!)
        let gFloat = CGFloat(Double(gUnwrapped)!)
        let bFloat = CGFloat(Double(bUnwrapped)!)
        let aFloat = CGFloat(Double(aUnwrapped)!)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
    }
}
