//
//  WelcomeView.swift
//  sosomk
//
//  Created by MoonCai on 2017/11/24.
//  Copyright © 2017年 Moon. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    var imageNames: [String] = [] {
        didSet {
          pageControl.numberOfPages = imageNames.count
        }
    }
    
    private let welcomeCellID = "welcomeCellID"
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

   private lazy var welcomeCollecView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = UIScreen.main.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        collectView.backgroundColor = .clear
        collectView.isPagingEnabled = true
        collectView.showsHorizontalScrollIndicator = false
        collectView.bounces = false
        return collectView
    }()
    
    private lazy var pageControl: UIPageControl = UIPageControl()
    
    private var currentPage: Int = 0
    
    var welcomeClosure:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(welcomeCollecView)
        addSubview(pageControl)
        
        welcomeCollecView.dataSource = self
        welcomeCollecView.delegate = self
        welcomeCollecView.register(WelcomeCell.self, forCellWithReuseIdentifier: welcomeCellID)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50)
            ])
    }
    
    @objc private func jumpButtonAction() {
        welcomeClosure?()
    }
}

extension WelcomeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.isEmpty ? 0 : (imageNames.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: welcomeCellID, for: indexPath) as! WelcomeCell
        cell.jumpBtn.isHidden = (indexPath.row == imageNames.count)
        cell.imageView.image = (indexPath.row == imageNames.count ? nil : UIImage(named: imageNames[indexPath.row]))
        cell.jumpBtn.addTarget(self, action: #selector(jumpButtonAction), for: .touchUpInside)
        return cell
    }
}

extension WelcomeView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        currentPage = Int(offSetX / screenWidth + 0.5)
        pageControl.currentPage = currentPage
        //最后一张图片滑过一半时隐藏pageControl
       pageControl.isHidden = (currentPage == imageNames.count)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && currentPage == imageNames.count {
            removeFromSuperview()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentPage == imageNames.count {
            removeFromSuperview()
        }
    }
}

fileprivate class WelcomeCell: UICollectionViewCell {
    
    private(set) lazy var imageView: UIImageView = UIImageView()
    private(set) lazy var jumpBtn: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.layer.cornerRadius = 9
        btn.setTitle("立即开启", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(jumpBtn)
        
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        jumpBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jumpBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            jumpBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            jumpBtn.widthAnchor.constraint(equalToConstant: 140),
            jumpBtn.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}
