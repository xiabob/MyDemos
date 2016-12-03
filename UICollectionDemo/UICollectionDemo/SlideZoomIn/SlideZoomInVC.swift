//
//  SlideZoomInVC.swift
//  UICollectionDemo
//
//  Created by xiabob on 16/12/3.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

class SlideZoomInVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private lazy var collectionView: UICollectionView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let flow = SlideZoomInLayout()
        let view: UICollectionView = UICollectionView(frame: rect, collectionViewLayout: flow)
        view.backgroundColor = UIColor.white
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let color = UIColor(red: CGFloat(arc4random()%255) / CGFloat(255),
                            green: CGFloat(arc4random()%255) / CGFloat(255),
                            blue: CGFloat(arc4random()%255) / CGFloat(255),
                            alpha: 1)
        cell.backgroundColor = color
        
        return cell
    }
    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width*0.6, height: view.frame.height*0.6)
    }
}
