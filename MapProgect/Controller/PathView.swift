//
//  PathView.swift
//  MapProgect
//
//  Created by Всеволод Андрющенко on 26/02/2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class PathView: UIView {

    //var textArray:[String]
    
    var path: UIBezierPath!
    
    var roadPoint = [PointRoad]()
    var roadCreate = [Road]()
   
    let mapLayerStrart = CAShapeLayer()
    let mapLayerEnd = CAShapeLayer()
    let pathLayer = CAShapeLayer()
    
    //Mark: метод для отрисовки линий
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        roadLayer()
    }
    //Mark: послойное добавление объектов
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
       //buildingLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func roadLayer(){
        let roads = roadLoad()
        printRoads(roads: roads)
    }
    // Mark: отрисовка полощадных объктов
    func buildingLayer() {
        
        let arrayPoint = loadBuilding()
        let buildingLayer = CAShapeLayer()
        buildingLayer.path = printBuilding(arrayPoint: arrayPoint).cgPath
        
        self.layer.addSublayer(buildingLayer)
        let style = BuildinStyle()
        buildingLayer.strokeColor = style.strokeColor
        buildingLayer.lineWidth = style.width
        buildingLayer.fillColor = style.fillColor
        
        
    }
    
    func printRoads(roads:[Road]){
        
        guard let path = UIGraphicsGetCurrentContext() else
        {
            return
        }
        for road in roads{
            let point1 = CGPoint(x: road.firstPointX/10.0, y: road.firstPointY/10.0)
            let point2 = CGPoint(x: road.secondPointX/10.0, y: road.secondPointY/10.0)
           // print(point1)
           // print(point2)
            path.move(to: point1)
            path.addLine(to: point2)
            
            let style = RoadStyle()
            
            var color:CGColor
            var width:CGFloat
            
            switch road.cat{
            case 1:
                color = style.colorCat1
                width = style.width1
            case 2:
                color = style.colorCat2
                width = style.width2
            case 3:
                color = style.colorCat3
                width = style.width3
            case 4:
                color = style.colorCat4
                width = style.width4
            case 5:
                color = style.colorCat5
                width = style.width5
            default:
                return
                }
            
            path.setStrokeColor(color)
            path.setLineWidth(width)
            path.setLineCap(.square)
            path.strokePath()
        }
    }
    
    
    func printBuilding(arrayPoint:[Building])->UIBezierPath{
        
        let path = UIBezierPath()
        
        for build in arrayPoint{
            var first = true
            for a in build.point{
                if first{
                    path.move(to: a)
                    first = false
                }else{
                    path.addLine(to: a)
                }
                
            }
            
        }
        path.close()
        
        return path
    }
    
    func changePointStart(pointX: Double, pointY: Double) -> (PointRoad){
        
        let path = UIBezierPath()
        var changedPoint:PointRoad = roadPoint[0]
        var min = 100000.0
    
        for point in roadPoint{
            let length = sqrt((pow(point.pointX/10 - pointX, 2))+(pow(point.pointY/10 - pointY, 2)))
            if length < min{
                min = length
                changedPoint = point
            }
        }
        print(changedPoint.pointX)
        print(changedPoint.pointY)
        
        let point1 = CGPoint(x: pointX, y: pointY)
        let point2 = CGPoint(x: changedPoint.pointX/10.0, y:changedPoint.pointY/10.0 )
        
    
        path.move(to: point1)
        path.addLine(to: point2)
        path.close()
        
        mapLayerStrart.path = path.cgPath
        mapLayerStrart.strokeColor = UIColor.green.cgColor
        mapLayerStrart.lineWidth = 10
        mapLayerStrart.lineCap = CAShapeLayerLineCap.square
        
        self.layer.addSublayer(mapLayerStrart)
        
       // mapLayerStrart.removeFromSuperlayer()
        
        return (changedPoint)
    }
    

func changePointEnd(pointX: Double, pointY: Double) -> (PointRoad){
    
    let path = UIBezierPath()
    var changedPoint:PointRoad = roadPoint[0]
    var min = 100000.0
    
    for point in roadPoint{
        let length = sqrt((pow(point.pointX/10 - pointX, 2))+(pow(point.pointY/10 - pointY, 2)))
        if length < min{
            min = length
            changedPoint = point
        }
    }
    print(changedPoint.pointX)
    print(changedPoint.pointY)
    
    let point1 = CGPoint(x: pointX, y: pointY)
    let point2 = CGPoint(x: changedPoint.pointX/10.0, y:changedPoint.pointY/10.0 )
    
    
    path.move(to: point1)
    path.addLine(to: point2)
    path.close()
    
    mapLayerEnd.path = path.cgPath
    mapLayerEnd.strokeColor = UIColor.green.cgColor
    mapLayerEnd.lineWidth = 10
    mapLayerEnd.lineCap = CAShapeLayerLineCap.square
    
    self.layer.addSublayer(mapLayerEnd)
    
    //mapLayerEnd.removeFromSuperlayer()
    
    return (changedPoint)
}

    func removeRoad(){
        mapLayerEnd.removeFromSuperlayer()
        mapLayerStrart.removeFromSuperlayer()
    }
    
    func pathFind(pointStart: PointRoad, pointEnd: PointRoad) -> [PointRoad]?{
        
        var point = [PointRoad]()
        point.append(pointStart)
        var pointNow = pointStart;
        for index in 1...1000  {
            if (pointNow.id != pointEnd.id){
                pointNow = getNegborNodes(now: pointNow, end: pointEnd)
                point.append(pointNow)
            }
        }
        return point
    }
    
    func getNegborNodes(now:PointRoad, end: PointRoad)->PointRoad  {
       var changePoint:PointRoad = roadPoint[0]
       var length = 100000.0
        for road in roadCreate{
        if road.firstPointX == now.pointX && road.firstPointY == now.pointY{
            
           let buff = lengthOutCount(pointNowX: road.secondPointX/10, pointNowY: road.secondPointY/10, pointEnd: end)
                 if buff < length {
                     length = buff
                      for point in roadPoint{
                      if road.secondPointX == point.pointX && road.secondPointY == point.pointY{
                        changePoint = point
                    }
                 }
             }
         }
       }
        return changePoint
    }
    
    func lengthOutCount(pointNowX: Double, pointNowY: Double,   pointEnd:PointRoad ) -> Double{
        let length = abs(pointNowX/10 - pointEnd.pointX) + abs(pointNowY/10 - pointEnd.pointY)
        return length
    }
    
    
    func roadPrint(maps:[PointRoad]){
        let path = UIBezierPath()
        
        var first = true
        
        for map in maps {
            if first{
                 path.move(to: CGPoint(x: map.pointX/10, y: map.pointY/10))
                 first = false
            }else{
                path.addLine(to: CGPoint(x: map.pointX/10, y: map.pointY/10))
            
            
            path.close()
            
            pathLayer.path = path.cgPath
            pathLayer.strokeColor = UIColor.green.cgColor
            pathLayer.lineWidth = 10
            pathLayer.lineCap = CAShapeLayerLineCap.square
            self.layer.addSublayer(pathLayer)
             first = true 
            }
        }
        
    }
}
extension PathView{
    func  roadLoad() ->[Road] {
        
        var textArray:[String]
        var lineArray:[String]
        
        
        if  let path = Bundle.main.path(forResource: "Point", ofType: "txt"){
            if let text = try? String(contentsOfFile: path){
                 textArray = text.components(separatedBy: "\n")
                 textArray.remove(at: textArray.count-1)
                var couter = 1
                for line in textArray {
                    
                    lineArray = line.components(separatedBy: "\t")
                    lineArray[1].removeLast()
                    let point = PointRoad(id: couter, pointX: Double(lineArray[0])! , pointY: Double(lineArray[1])!)
                    roadPoint.append(point)
                    couter += 1
                    
                }
            }
        }
            
        if  let path = Bundle.main.path(forResource: "Road", ofType: "txt"){
            if let text = try? String(contentsOfFile: path){
                textArray = text.components(separatedBy: "\n")
                textArray.remove(at: textArray.count-1)
                var couter = 1
                for line in textArray {
                    
                    lineArray = line.components(separatedBy: "\t")
                    lineArray[3].removeLast()
                    let road = Road(id: couter, firstPointX: roadPoint[Int(lineArray[0])!-1].pointX, secondPointX: roadPoint[Int(lineArray[1])!-1].pointX , firstPointY:   roadPoint[Int(lineArray[0])!-1].pointY , secondPointY:  roadPoint[Int(lineArray[1])!-1].pointY , cat: Int(lineArray[2])!, some: Int(lineArray[3])!)
                    roadCreate.append(road)
                    couter += 1
                    
                }
            }
        }
        
        return roadCreate
    }
    
    func loadBuilding()->[Building]{
        
        var arrayPoint = [Building]()
        
        let a = Building(id: 1, point: [CGPoint(x: 200, y: 50),  CGPoint(x: 300, y: 50), CGPoint(x: 300, y: 100),  CGPoint(x: 200, y: 100) ], address: "myLand")
        
        arrayPoint.append(a)
        
        return arrayPoint
    }
}
