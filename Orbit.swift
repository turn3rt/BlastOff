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
    var oe: [Double]
    var rv: [Double]
    
    init(name: String, oe: [Double], rv: [Double]){
        self.name = name
        self.oe = oe
        self.rv = rv
    }
}

