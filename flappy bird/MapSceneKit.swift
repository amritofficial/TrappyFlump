//
//  MapSceneKit.swift
//  Flappy Bird
//
//  Created by Xcode User on 2018-12-11.
//  Copyright © 2018 Appfish. All rights reserved.
//  Abeer Faizan

import UIKit
import SpriteKit
import MapKit

class MapSceneKit: SKScene {
    
    // Using the didMove method to initialize the instance of map
    // and getting the current location
    override func didMove(to view: SKView) {
        let map : MKMapView! = MKMapView()
        map.delegate = self as? MKMapViewDelegate
        // below line is missing
        map.frame=CGRect(x: 0,y: 0,width: self.size.width,height: self.size.width);
        let location = CLLocationCoordinate2DMake(43.655360, -79.738170)
        map.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        map.addAnnotation(annotation)
        map.showAnnotations([annotation], animated: true)
        map.selectAnnotation( annotation, animated: true)
        map.center = CGPoint(x: self.size.width / 2, y: self.size.width / 2)
        view.addSubview(map)
        self.backgroundColor = SKColor.darkGray
    }
    
    // the
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var scene1:SKScene = GameScene(fileNamed: "GameScene")!
        scene1.scaleMode = .aspectFill
        
        self.view?.presentScene(scene1, transition: SKTransition.fade(withDuration: 0.5))
    }
}
