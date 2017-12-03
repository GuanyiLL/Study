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
        view.clipsToBounds = true
        return view
    }()
    var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var bgImageHeight: CGFloat = 250
    var backgroundImage: UIImage? {
        didSet {
            bgImageView.image = backgroundImage
        }
    }
    
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
        let targetWidth = backgroundImageViewWidth(by: backgroundImage)
        bgImageView.frame = CGRect(x: (contentView.frame.width - targetWidth) / 2, y: 0, width: targetWidth, height: bgImageHeight)
        bgImageView.backgroundColor = .red
        contentView.backgroundColor = .green
    }
    
    func backgroundImageViewWidth(by image: UIImage?) -> CGFloat {
        guard let image = image else { return 0 }
        let size = image.size
        let scale = size.width / size.height
        return floor(bgImageHeight * scale)
    }
}

extension ParallaxCollectionViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self.classForCoder())
    }
}
