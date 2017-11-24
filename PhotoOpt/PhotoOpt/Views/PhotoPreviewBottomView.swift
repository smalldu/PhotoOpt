//
//  PhotoPreviewBottomView.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

protocol PhotoPreviewBottomDelegate: class {
  func photoPreviewBottomViewDidComplete(_ view: PhotoPreviewBottomView)
  func photoPreviewBottomViewDidBack(_ view: PhotoPreviewBottomView)
}

class PhotoPreviewBottomView: UIView {
  
  weak var delegate: PhotoPreviewBottomDelegate?
  
  let backBtn: UIButton = {
    let btn = UIButton()
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    btn.setTitle("返回", for: .normal)
    btn.setTitleColor(UIColor.black, for: .normal )
    return btn
  }()
  
  let commitBtn: UIButton = {
    let btn = UIButton()
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    btn.setTitle("完成", for: .normal)
    btn.setTitleColor(UIColor.black, for: .normal )
    return btn
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareView()
  }
  
  func prepareView(){
    addSubview(backBtn)
    addSubview(commitBtn)
    backBtn.translatesAutoresizingMaskIntoConstraints = false
    commitBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10) ,
      backBtn.topAnchor.constraint(equalTo: self.topAnchor) ,
      backBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor ) ,
      commitBtn.topAnchor.constraint(equalTo: self.topAnchor) ,
      commitBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor ) ,
      commitBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
      ])
    
    commitBtn.addTarget(self, action: #selector(complete), for: .touchUpInside)
    backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
  }

  
  @objc func complete(){
    delegate?.photoPreviewBottomViewDidComplete(self)
  }
  @objc func back(){
    delegate?.photoPreviewBottomViewDidBack(self)
  }
  
  func changeSelectedCount(){
    let count = SelectedAssetManager.shared.selectedCount
    if count == 0{
      commitBtn.setTitle("完成", for: .normal)
    }else{
      commitBtn.setTitle("完成（\(count)）", for: .normal)
    }
  }
}
