//
//  Orbit.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/25/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

class Orbit {
    var name: String
    var rv: [Double]
    var oe: [Double]
    var isShown: Bool
    
    init(name: String, rv: [Double], oe: [Double], isShown: Bool){
        self.name = name
        self.rv = rv
        self.oe = oe
        self.isShown = isShown
    }
}

