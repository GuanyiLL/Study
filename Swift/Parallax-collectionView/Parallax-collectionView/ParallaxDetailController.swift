//
//  ParallaxDetailController.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/12/4.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

class ParallaxDetailController: UIViewController {
    
    var image:UIImage?
    var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 200, width: 30, height: 30))
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(ParallaxDetailController.popViewController), for: .touchUpInside)
        return button
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        imageView.isHidden = true
        return imageView
    }()
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(imageView)
        view.addSubview(backButton)
        imageView.image = image
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(imageView)
    }

}
