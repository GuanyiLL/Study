//
//  ParallaxCollectionViewCell.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/11/30.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

class ParallaxCollectionViewCell: UICollectionViewCell {
    
}

extension ParallaxCollectionViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self.classForCoder())
    }
}
