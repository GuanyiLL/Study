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

class HowToNameThisController
: UIViewController
, ARSCNViewDelegate {

    @IBOutlet weak var arView: ARSCNView!
    
    var displayLink: CADisplayLink!
    var objectsMarked:Dictionary<UUID, VNRectangleObservation> = Dictionary()
    
    lazy var request: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
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
    
    lazy var trackObjectRequest: VNDetectRectanglesRequest = {
        let request = VNDetectRectanglesRequest(completionHandler: processTrackingObject)
        return request
    }()
    
    func processTrackingObject(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            //                self.label.text = "Error\n\(error!.localizedDescription)"
            return
        }
        
        let objects = results as! [VNRectangleObservation]
        if objects.count == 1 {

            let descriptions = objects.first!.boundingBox.debugDescription
            print(descriptions)
            
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
//                self.label.text = "Error\n\(error!.localizedDescription)"
                return
            }
            
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
//                self.label.text = "Nothing recognized."
            } else {
                let topClassifications = classifications.first
                let descriptions = topClassifications.map { classification in
                    return String(format: "  %@ - [%.2f]%%", classification.identifier, classification.confidence * 100)
                }
                
//                print(descriptions)
//                self.label.text = descriptions.joined(separator: "\n")
            }
        }
    }
    
    func startTrackingObject(for image: CIImage) {
        
        guard let pixelBuffer = image.pixelBuffer else { return }
        let sequenceHandler = VNSequenceRequestHandler()
        
        let obsercationKeys = self.objectsMarked
        var obsercationRequest = [VNTrackObjectRequest]()

        obsercationKeys.forEach { (key, value) in
            guard let obsercation = self.objectsMarked[key] else {
                return
            }
            
            let request = VNTrackObjectRequest(detectedObjectObservation: obsercation, completionHandler: { (request, error) in

                
            })
            
            request.trackingLevel = .accurate
            obsercationRequest.append(request)
        }
        do {
            try sequenceHandler.perform(obsercationRequest, on: pixelBuffer)
        } catch {
            print("EEEEEERROR")
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
    
    @objc func refreshTheWorld() {
        guard let pixelBuffer = arView.session.currentFrame?.capturedImage else {
            print("Error")
            return
        }
        
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        updateClassifications(for: image)
        startTrackingObject(for: image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        arView.delegate = self
        let scene = SCNScene()
        arView.scene = scene
        arView.autoenablesDefaultLighting = true
        arView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let  configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        displayLink = CADisplayLink(target: self, selector: #selector(HowToNameThisController.refreshTheWorld))
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink.invalidate()
    }
    
}
