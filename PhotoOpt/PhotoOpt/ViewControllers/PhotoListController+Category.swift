//
//  PhotoListController+Category.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

extension PhotoListController {
  
  // 点击顶部
  @objc func clickTitle(){
    if isAnimating {
      return
    }
    isAnimating = true
    var transform: CGAffineTransform!
    if self.state == .normal {
      addCategoryIfNeeded()
      categoryVC.assetCategorys = self.assetManager.categorys
      categoryVC.view.isHidden = false
      categoryVC.view.backgroundColor = UIColor.black.withAlphaComponent(0)
      transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
    }else{
      categoryVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      categoryVC.view.isHidden = false
      categoryVC.fadeOut()
      transform = CGAffineTransform.identity
    }
    UIView.animate(withDuration: 0.3, animations: {
      self.angel.transform = transform
      if self.state == .normal {
        self.categoryVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      }else{
        self.categoryVC.view.backgroundColor = UIColor.black.withAlphaComponent(0)
      }
    }) { _ in
      self.isAnimating = false
      if self.state == .normal {
        self.state = .modeling
        self.categoryVC.view.isHidden = false
      }else{
        self.state = .normal
        self.categoryVC.view.isHidden = true
      }
    }
  }
  
  func addCategoryIfNeeded(){
    if !self.childViewControllers.contains(categoryVC){
      self.addChildViewController(categoryVC)
      view.addSubview(categoryVC.view)
      categoryVC.view.frame = view.bounds
      categoryVC.didMove(toParentViewController: self)
      categoryVC.delegate = self
    }else{
      categoryVC.fadeIn()
    }
  }
}


extension PhotoListController: PhotoCategoryDelegate{
  
  func categoryDidSelected(_ controller: PhotoCategoryController, category: AssetCategory) {
    self.category = category
    clickTitle()
    self.collectionView.reloadData()
  }
  
}

