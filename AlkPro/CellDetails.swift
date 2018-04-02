//
//  CellDetails.swift
//  AlkPro
//
//  Created by Sierra on 3/30/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import Foundation

class CellDetails {
    var name:String?
    var date:String?
    var days:Int?
    
    init(name:String,date:String,days:Int) {
        self.name=name
        self.date=date
        self.days=days
    }
}
