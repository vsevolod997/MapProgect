//
//  Buildig.swift
//  MapProgect
//
//  Created by Всеволод Андрющенко on 25/02/2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation
import UIKit

class Building {
    let id: Int
    var point: [CGPoint]
    let address: String?
    
    
    init(id:Int, point:[CGPoint], address: String?){
        self.id  = id
        self.point = point
        self.address  = address
    }
}

