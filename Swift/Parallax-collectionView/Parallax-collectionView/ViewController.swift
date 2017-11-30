//
//  ViewController.swift
//  Parallax-collectionView
//
//  Created by Guanyi on 2017/11/30.
//  Copyright © 2017年 yiguan. All rights reserved.
//

import UIKit

class ViewController
: UIViewController
, UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var imgNames: NSArray = ["01","02","03","04"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ParallaxCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ParallaxCollectionViewCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParallaxCollectionViewCell.reuseIdentifier, for: indexPath) as! ParallaxCollectionViewCell
        cell.bgImageView.image = UIImage(named: "0\(indexPath.row % 4 + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.size.height - 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
        print("Did select item at row:[\(indexPath.row)]")
    }
    
}

