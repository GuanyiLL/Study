//
//  CoreMLViewController.swift
//  CoreMLResearching
//
//  Created by Guanyi on 2018/1/11.
//  Copyright © 2018年 yiguan. All rights reserved.
//

import UIKit

class CoreMLViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let model = MobileNet()
    override func viewDidLoad() {
        super.viewDidLoad()
        let input = imageView.image!.pixelBuffer(width: 224, height: 224)
        do {
            let output = try model.prediction(image: input!)
            guard let probability = output.classLabelProbs[output.classLabel] else { return }
            label.text = "\(output.classLabel) \nAlmost: \(String(format: "%.2f", probability * 100.0))%"
        } catch {
            fatalError("Runtime Error -- \(error)")
        }
    }
}


