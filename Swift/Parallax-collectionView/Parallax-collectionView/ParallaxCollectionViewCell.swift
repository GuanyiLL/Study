//
//  ParallaxCollectionViewCell.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/11/30.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

class ParallaxCollectionViewCell
: UICollectionViewCell
, ParallaxCell {
    var container: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        return view
    }()
    var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        self.clipsToBounds = true
        contentView.addSubview(container)
        container.addSubview(bgImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = contentView.bounds
        bgImageView.frame = container.bounds
    }
}

extension ParallaxCollectionViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self.classForCoder())
    }
}
