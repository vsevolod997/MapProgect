//
//  PathSearch.swift
//  MapProgect
//
//  Created by Всеволод Андрющенко on 29/03/2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class PathSearch{
    
    var point: PointRoad
    var lengthTo: Double
    var pointCome: PointRoad?
    var lengthAll: Double
    var lengthFullPathCount:Double
    
    init(point:PointRoad, lengthTo:Double, pointCome: PointRoad?, lenghtAll: Double) {
        
        self.point = point
        self.lengthTo = lengthTo
        self.pointCome = pointCome
        self.lengthAll = lenghtAll
        self.lengthFullPathCount = lenghtAll+lengthTo
    }
}
