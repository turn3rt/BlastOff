//
//  OrbitCell.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/28/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class OrbitCell: UITableViewCell {

    @IBOutlet weak var orbitName: UILabel!
    var orbit = Orbit(name: String(),
                      rv: [Double](),
                      oe: [Double](),
                      isShown: Bool())
    
}




//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//}

