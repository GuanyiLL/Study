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
import CoreML
import Vision

class ScanWorldController
: UIViewController
, ARSCNViewDelegate {

    @IBOutlet weak var arView: ARSCNView!
    @IBOutlet weak var classificationLabel: UILabel!
    
    var lastPrediction = ""
    
    lazy var request: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Resnet50().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                guard let `self` = self else { return }
                self.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed\n\(error)")
        }
    }()
 
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Error\n\(error?.localizedDescription ?? "")"
                return
            }
            
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "  %@ - [%.2f]%%", classification.identifier, classification.confidence * 100)
                }
                self.classificationLabel.text = descriptions.joined(separator: "\n")
                
                if let mostLikelyResult = topClassifications.first?.identifier.split(separator: ",").first {
                    self.lastPrediction = String(mostLikelyResult)
                } else {
                    self.lastPrediction = topClassifications.first?.identifier ?? ""
                }
            }
        }
    }
    
    func updateClassifications(for image: CIImage) {
        let orientation = CGImagePropertyOrientation(.up)
        let handler = VNImageRequestHandler(ciImage: image, orientation: orientation)
        do {
            try handler.perform([self.request])
        } catch {
            print("Failed\n\(error.localizedDescription)")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        refreshTheWorld()
    }
    
    @objc func refreshTheWorld() {
        guard let pixelBuffer = arView.session.currentFrame?.capturedImage else {
            DispatchQueue.main.async {
                self.classificationLabel.text = "Waiting..."
            }
            return
        }
        
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        updateClassifications(for: image)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let results = arView.hitTest(touch.location(in: arView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        let target = SCNNode()
        target.scale = SCNVector3(0.01,0.01,0.01)
        let shape = SCNSphere(radius: 0.5)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.cyan
        material.lightingModel = .phong
        shape.firstMaterial = material
        target.geometry = shape
        target.position = hitPosition
        
        let text = SCNText(string: self.lastPrediction, extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 3)
        
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.cyan
        textMaterial.lightingModel = .constant
        textMaterial.isDoubleSided = true
        text.firstMaterial = textMaterial
        
        text.alignmentMode = kCAAlignmentCenter//位置
        text.truncationMode = kCATruncationMiddle//........

        let textNode = SCNNode(geometry: text)
//        textNode.scale = SCNVector3(1/100.0,1/100.0,1/100.0) // 坑来了
        let (minBound, maxBound) = textNode.boundingBox
        textNode.position = SCNVector3Make( 0.0 - (maxBound.x - minBound.x)/2, 0.5, 0)
        target.addChildNode(textNode)

        arView.scene.rootNode.addChildNode(target)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.delegate = self
        let scene = SCNScene()
        arView.scene = scene
        arView.autoenablesDefaultLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let  configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
