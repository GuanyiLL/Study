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
            var targetWidth = backgroundImageViewWidth(by: backgroundImage)
            if targetWidth <= ItemSize.width {
                targetWidth += 20
            }
            bgImageView.frame.size = CGSize(width: targetWidth, height: bgImageHeight)
        }
    }
    
    func movingBackgroundImageView(collectionView: UICollectionView) {
        let width = ItemSize.width
        var deltaX = (frame.origin.x + frame.width/2) - collectionView.contentOffset.x
        deltaX = min(width, max(deltaX, 0))
        var move : CGFloat = deltaX / collectionView.bounds.width * (ItemSize.width + ItemSize.merge)
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

extension UIView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self.classForCoder())
    }
    
    var snapshot: UIImageView {
        let container  = UIImageView(image: UIView.shot(withView: self))
        container.frame.size = self.bounds.size;
        return container
    }

    static func shot(withView v: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(v.bounds.size)
        v.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
