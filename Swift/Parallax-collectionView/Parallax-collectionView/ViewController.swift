//
//  ViewController.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/11/30.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

struct ItemSize {
    static let width: CGFloat = 280;
    static let height: CGFloat = 400;
    static let merge: CGFloat = 20;
}

class ViewController
: UIViewController
, UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    var imgNames: NSArray = ["01","02","03","04"];
    
    //MARK:- Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParallaxCollectionViewCell.reuseIdentifier, for: indexPath) as! ParallaxCollectionViewCell
        cell.backgroundImage = UIImage(named: "0\(indexPath.row % 4 + 1)")
        cell.index = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ItemSize.width, height: ItemSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
        print("Did select item at row:[\(indexPath.row)]")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //This following code wrote like shit
        
        var targetCell: ParallaxCollectionViewCell?
        var targetX: CGFloat = 0

        if velocity.x == 0 {
            var quotient:CGFloat = collectionView.contentOffset.x / (ItemSize.width + ItemSize.merge)
            let i = floor(quotient)
            quotient = CGFloat(quotient - i)

            if quotient > 0.5 {
                 targetCell = collectionView.visibleCells.max { $0.frame.minX < $1.frame.minX } as? ParallaxCollectionViewCell
            } else {
                 targetCell = collectionView.visibleCells.min { $0.frame.minX < $1.frame.minX } as? ParallaxCollectionViewCell
            }
        } else if velocity.x > 0 {
            targetCell = collectionView.visibleCells.max { $0.frame.minX < $1.frame.minX } as? ParallaxCollectionViewCell
        } else {
            targetCell = collectionView.visibleCells.min { $0.frame.minX < $1.frame.minX } as? ParallaxCollectionViewCell
        }
        guard let cell = targetCell else { fatalError() }
        guard let indexPath = collectionView.indexPath(for: cell) else { fatalError() }
        targetX = CGFloat(indexPath.row) * (ItemSize.width + ItemSize.merge)
        targetContentOffset.pointee.x = targetX
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            collectionView.visibleCells
                .map{ $0 as! ParallaxCollectionViewCell }
                .forEach { $0.movingBackgroundImageView(collectionView: collectionView) }
        }
    }

    // MARK:- Liftcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
    }
    
    func configCollectionView() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = ItemSize.merge
        layout.headerReferenceSize = CGSize(width: (UIScreen.main.bounds.width - ItemSize.width) / 2, height: ItemSize.height)
        layout.footerReferenceSize = CGSize(width: (UIScreen.main.bounds.width - ItemSize.width) / 2, height: ItemSize.height)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(ParallaxCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ParallaxCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(collectionView)
    }
    
}

