//
//  DataStructure.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/27/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

/*
 A note on the overall memory structure of this orbit app:
 There is a constant varibale called savedNumberOfOrbits that gets updated every time the user saves an orbit from the new orbit button.
 
 There are four data points saved in UserDefaults.Standard repeating as follows:
 [0] orbitName  =
 [1] orbitRVPCI = Coordinates in a 1x6 row matrix
 [2] orbitOE    = Coordinates in a 1x6 row matrix
 [3] True       = Bool indicating if the orbit is shown on the ARScene or not. Default saved to true, and is modified in the ARSettings page. 

 
 
 
 
 
 
 
 */
