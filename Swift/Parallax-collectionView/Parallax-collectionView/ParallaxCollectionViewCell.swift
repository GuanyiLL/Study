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
            let targetWidth = backgroundImageViewWidth(by: backgroundImage)
            bgImageView.frame.size = CGSize(width: targetWidth, height: bgImageHeight)
        }
    }
    
    func movingBackgroundImageView(collectionView: UICollectionView) {
        
        let width = ItemSize.width + ItemSize.merge
        
        var deltaY = (frame.origin.x + frame.width/2) - collectionView.contentOffset.x
        deltaY = min(width, max(deltaY, 0)) // range
        
        var move : CGFloat = (deltaY / width) * width
        move = move / 2.0  - move
        
        bgImageView.frame.origin.x = move
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.clipsToBounds = true
        contentView.addSubview(container)
        container.addSubview(bgImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = contentView.bounds
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
