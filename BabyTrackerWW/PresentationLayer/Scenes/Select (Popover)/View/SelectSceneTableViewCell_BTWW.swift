//
//  SelectSceneTableViewCell_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 14.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class SelectSceneTableViewCell_BTWW: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        print("SelectSceneTableViewCell - is Deinit!")
    }

}
