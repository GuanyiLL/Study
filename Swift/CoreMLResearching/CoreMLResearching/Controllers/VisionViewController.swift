//
//  VisionViewController.swift
//  CoreMLResearching
//
//  Created by Guanyi on 2018/1/15.
//  Copyright © 2018年 yiguan. All rights reserved.
//

import UIKit
import Vision

class VisionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let model = try VNCoreMLModel(for: MobileNet().model)
        
        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
        })
        request.imageCropAndScaleOption = .centerCrop
        
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.label.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        }
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        
    }

}
