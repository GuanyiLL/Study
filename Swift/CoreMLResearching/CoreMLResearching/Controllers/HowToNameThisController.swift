//
//  HowToNameThisController.swift
//  CoreMLResearching
//
//  Created by Guanyi on 2018/1/16.
//  Copyright © 2018年 yiguan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class HowToNameThisController
: UIViewController
, ARSCNViewDelegate {

    @IBOutlet weak var arView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        arView.delegate = self
        let scene = SCNScene()
        arView.scene = scene
        arView.autoenablesDefaultLighting = true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
}
