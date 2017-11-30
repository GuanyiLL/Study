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
, UICollectionViewDataSource {

    var collectionView = UICollectionView() {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            view.addSubview(collectionView)
        }
    }
    var datas: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParallaxCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
        print("Did select item at row:[\(indexPath.row)]")
    }
    
}

