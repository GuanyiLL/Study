//
//  ParallaxFlowLayout.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/12/5.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

class ParallaxFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        assert(self.collectionView?.numberOfSections == 1, "Multiple sections aren't supported!")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        print("\(String(describing: attributes))")
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        print("\(String(describing: attributes))")
        return attributes
    }
    
}
