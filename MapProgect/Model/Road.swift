//
//  File.swift
//  MapProgect
//
//  Created by Всеволод Андрющенко on 17/02/2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class Road {
    
    let id: Int
    let firstPointX: Double
    let firstPointY: Double
    let secondPointX: Double
    let secondPointY: Double
    let cat: Int
    let some: Int
    
    init (id: Int, firstPointX:Double, secondPointX:Double, firstPointY:Double, secondPointY:Double, cat:Int, some:Int ){
        
        self.id = id
        self.firstPointX = firstPointX
        self.firstPointY = firstPointY
        self.secondPointX = secondPointX
        self.secondPointY = secondPointY
        self.cat = cat
        self.some = some
    }

}
