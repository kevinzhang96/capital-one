//
//  Enums.swift
//  pushups
//
//  Created by Alexander, Jared on 12/23/15.
//  Copyright © 2015 tysonsapps. All rights reserved.
//

enum Voice: Int {
    case Male = 0
    case Female = 1
    case Child = 2

    static var count: Int { return Voice.Child.rawValue + 1 }
    
    var description: String {
        switch self {
            case .Male: return "Male"
            case .Female: return "Female"
            case .Child   : return "Child"
        }
    }
    
    var value: Float {
        switch self {
            case .Male: return 0.7
            case .Female: return 1.5
            case .Child   : return 2.5
        }
    }
}