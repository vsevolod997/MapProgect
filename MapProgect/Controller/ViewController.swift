//
//  ViewController.swift
//  MapProgect
//
//  Created by Всеволод Андрющенко on 17/02/2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate {

    var buttonView = UIView()
    var buttonOrigin = UIButton()//откуда
    var buttonDestination = UIButton()// куда
    var buttonGo = UIButton()
    
    var naviView = UIView()
    var plussButton = UIButton()
    var minusButton = UIButton()
    var scrollView = UIScrollView()
    
    var pointFirs = UIView()
    var pointSecond = UIView()
    
    var attachmentBehavior: UIAttachmentBehavior?
    
    
    var pathView = PathView()
    
    var zoom: CGFloat = 1.0
    
    var click: Bool = true
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonView.frame = CGRect(x: self.view.frame.width - self.view.frame.width/8, y: self.view.frame.height/2, width: 150, height: 250)
        buttonView.backgroundColor = .white
        view.addSubview(buttonView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var pointX:CGFloat = 0
    var pointY:CGFloat = 20
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        pathView = PathView(frame: CGRect(x: pointX,
                                              y: pointY,
                                              width: 4000,
                                              height: 4000 ))
        
        
        self.view.addSubview(pathView)
        
        scrollView.indicatorStyle = .black
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.addSubview(pathView)
        scrollView.contentSize = pathView.bounds.size
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 0.2 // 20 % от нормального размера
        scrollView.maximumZoomScale = 2.8
        
        createButtonView()
        createNaviView()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pathView
    }

    
    func createButtonView(){
        
        buttonView = UIView(frame: CGRect(x: self.view.frame.width - self.view.frame.width/6, y: self.view.frame.height/2, width: 60, height: 80))
        buttonView.backgroundColor = .white
        buttonView.alpha = 0.8
        buttonView.layer.cornerRadius = 10
        createButton()
        view.addSubview(buttonView)
    }
    
    func createButton(){
        
        plussButton = UIButton(type: .roundedRect)
        plussButton.frame = CGRect(x:5 , y: -5 , width: 50, height: 50)
        plussButton.setTitle("PLUS", for: .normal)
        plussButton.addTarget(self, action: #selector(plussTapped(sender:)), for: .touchUpInside)
        
        minusButton = UIButton(type: .roundedRect)
        minusButton.frame = CGRect(x:5, y: 35, width: 50, height: 50)
        minusButton.setTitle("MINUS", for: .normal)
        minusButton.addTarget(self, action: #selector(minusTapped(sender:)), for: .touchUpInside)
        buttonView.addSubview(plussButton)
        buttonView.addSubview(minusButton)
       // buttonView.addSubview(buttonGo)
    }
 
    
    @objc func plussTapped(sender: UIButton){

        zoom = scrollView.zoomScale
        if zoom < 2.0{
            zoom += 0.2
        }
        
        
        scrollView.setZoomScale(zoom, animated: true)
        zoom = scrollView.zoomScale
        scrollView.alpha = 1
        //print()
        pointSecond.transform = CGAffineTransform(scaleX: 1/zoom, y: 1/zoom)
        pointFirs.transform = CGAffineTransform(scaleX: 1/zoom, y: 1/zoom)
        print("PF",pointFirs.frame)
        print("PS",pointSecond.frame)
    }
    
    @objc func minusTapped(sender: UIButton){
        
        
       
        if zoom > 0.2{
            zoom -= 0.2
        }
        print("VF",view.frame)
        scrollView.setZoomScale(zoom, animated: true)
        zoom = scrollView.zoomScale
        scrollView.alpha = 1
       // print(scrollView.contentOffset)
        pointSecond.transform = CGAffineTransform(scaleX: 1/zoom, y: 1/zoom)
        pointFirs.transform = CGAffineTransform(scaleX: 1/zoom, y: 1/zoom)
        print("PF",pointFirs.frame)
        print("PS",pointSecond.frame)
    }
    
    
    
    
    func createNaviView(){
        
        naviView = UIView(frame: CGRect(x: 10, y: self.view.frame.height - 100, width: self.view.frame.width-20, height: self.view.frame.height/12))
        naviView.backgroundColor = .white
        naviView.alpha = 0.8
        naviView.layer.cornerRadius = 10
        createNaviButton()
        view.addSubview(naviView)
    }
    

    func createNaviButton(){
        
        buttonOrigin = UIButton(type: .roundedRect)
        buttonOrigin.frame = CGRect(x:naviView.frame.width - (naviView.frame.width - 20), y: naviView.frame.height/5 , width: 70, height: 50)
        buttonOrigin.setTitle("Origin", for: .normal)
        buttonOrigin.addTarget(self, action: #selector(originTapped(sender:)), for: .touchUpInside)
        
        
        buttonDestination = UIButton(type: .roundedRect)
        buttonDestination.frame = CGRect(x:naviView.frame.width  - naviView.frame.width/1.6, y: naviView.frame.height/5, width: 100, height: 50)
        buttonDestination.setTitle("Destination", for: .normal)
        buttonDestination.addTarget(self, action: #selector(destinationTapped(sender:)), for: .touchUpInside)
        
        
        buttonGo = UIButton(type: .roundedRect)
        buttonGo.frame = CGRect(x:naviView.frame.width - 100, y: naviView.frame.height/5 , width: 100, height: 50)
        buttonGo.setTitle("GO", for: .normal)
        buttonGo.addTarget(self, action: #selector(goTapped(sender:)), for: .touchUpInside)
        
        naviView.addSubview(buttonGo)
        naviView.addSubview(buttonOrigin)
        naviView.addSubview(buttonDestination)
    }
    
    @objc func originTapped(sender: UIButton){
        
    let x = scrollView.contentOffset.x/zoom + view.frame.width/2/zoom
    let y = scrollView.contentOffset.y/zoom + view.frame.height/2/zoom
        
    addPointStart(pointX: x, pointY: y)
     createGestureRecognizerStart()
    }
    
    @objc func destinationTapped(sender: UIButton){
        
    let x = scrollView.contentOffset.x/zoom + view.frame.width/2/zoom
    let y = scrollView.contentOffset.y/zoom + view.frame.height/2/zoom
        
    addPointEnd(pointX: x, pointY: y)
    createGestureRecognizerSecond()
        
    }
    
    @objc func goTapped(sender: UIButton){
        
        var pointStart: PointRoad
        var pointEnd: PointRoad
        
        var startX:Double
        var startY:Double
        var endX:Double
        var endY:Double
        
        if click{
            buttonGo.setTitle("Stop", for: .normal)
            
            
            startX = Double(pointFirs.center.x)
            startY = Double(pointFirs.center.y)
            endX = Double(pointSecond.center.x)
            endY = Double(pointSecond.center.y)
            
            if startY != 0.0 && startX != 0.0 && endX != 0.0 && endY != 0.0{
                
                pointStart = pathView.changePointStart(pointX: startX, pointY: startY)
                pointEnd =  pathView.changePointEnd(pointX: endX, pointY: endY)
                
                let path = pathView.pathFind(pointStart: pointStart, pointEnd: pointEnd)
                if let path = path {
                    pathView.roadPrint(maps: path)
                }
                
                
            }
            
            
        }else {
            
            pointFirs.center = CGPoint(x: 0, y: 0)
            pointSecond.center = CGPoint(x: 0, y: 0)
            
            buttonGo.setTitle("GO", for: .normal)
            
            pointFirs.removeFromSuperview()
            pointSecond.removeFromSuperview()
            pathView.removeRoad()
        }
        
        click = !click
    }
    
    func addPointStart(pointX:CGFloat, pointY:CGFloat ){
        
        let viewS  = pointFirs as? UIView
        viewS?.removeFromSuperview()
        
        zoom = scrollView.zoomScale
        pointFirs = UIView(frame: CGRect(x: 0, y: 0, width: 40/zoom, height: 40/zoom))
        pointFirs.backgroundColor = .green
        pointFirs.layer.cornerRadius = 40/2/zoom
        
       
        pointFirs.center = CGPoint(x: pointX, y: pointY)
        pointFirs.layer.shadowRadius = 4.0
        pointFirs.layer.shadowOpacity = 0.6
        pointFirs.layer.shadowOffset = CGSize.zero
        
        pathView.addSubview(pointFirs)
        
    }
    
    func createGestureRecognizerStart(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
       pointFirs.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    
    @objc func handlePan(paramaPam: UIPanGestureRecognizer){
        
        zoom = scrollView.zoomScale
        if paramaPam.state == .began{
            //pointFirs.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            pointFirs.alpha = 0.5
        }else if paramaPam.state == .changed{
            let tapPoint = paramaPam.location(in: pathView)
            print(tapPoint)
            attachmentBehavior?.anchorPoint = tapPoint
            pointFirs.center = tapPoint
            
        }else if paramaPam.state == .ended{
            //pointFirs.transform = CGAffineTransform(scaleX: 1, y: 1)
            pointFirs.alpha = 1
        }
        
    }
    
    func addPointEnd(pointX: CGFloat, pointY:CGFloat ){
        
        let viewS  = pointSecond as? UIView
         viewS?.removeFromSuperview()
        
        
        zoom = scrollView.zoomScale
        pointSecond = UIView(frame: CGRect(x: 0, y: 0, width: 40/zoom, height: 40/zoom))
        pointSecond.backgroundColor = .red
        pointSecond.layer.cornerRadius = 40/2/zoom
        
        pointSecond.center = CGPoint(x: pointX, y: pointY)
        pointSecond.layer.shadowRadius = 4.0
        pointSecond.layer.shadowOpacity = 0.6
        pointSecond.layer.shadowOffset = CGSize.zero
        pathView.addSubview(pointSecond)
    }
    
    func createGestureRecognizerSecond(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanSecond(paramaPam:)))
        pointSecond.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    
    @objc func handlePanSecond(paramaPam: UIPanGestureRecognizer){
        
        zoom = scrollView.zoomScale
        if paramaPam.state == .began {
            pointSecond.alpha = 0.5
        }else if paramaPam.state == .changed{
            
            let tapPoint = paramaPam.location(in: pathView)
            print(tapPoint)
            attachmentBehavior?.anchorPoint = tapPoint
            pointSecond.center = tapPoint
            
        }else if paramaPam.state == .ended{
            pointSecond.alpha = 1
        }
        
    }
    
    
}

extension ViewController{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       // print("скрол1")
        self.scrollView.alpha = 0.5
    }
    //начало прокрутки
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let p = "начинаеться прокрутка"
      //  print(p)
      //  print(scrollView.contentOffset)
        self.scrollView.alpha = 0.5
    }
    //окончание прокрутки
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      //  print("вызов после прокрутки")
        self.scrollView.alpha = 1
    }
    //гарантия прокрутки окончания
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       // print(" гарантирует что вернет alpa(прозрачность)")
        self.scrollView.alpha = 1
    }
}
