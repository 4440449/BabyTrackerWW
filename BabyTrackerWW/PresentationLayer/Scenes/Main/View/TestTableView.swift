//
//  TestTableView.swift
//  BabyTrackerWW
//
//  Created by Max on 10.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit

class TestTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()
        print("contentOffset == \(contentOffset)")
        print("contentSize == \(contentSize)")
        
        
        
//        print("contentInset == \(contentInset)")
//        print("contentScaleFactor == \(contentScaleFactor)")
    }

}
