//
//  PhotoBottomView.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class PhotoBottomView: UIView {
  
  let previewBtn: UIButton = {
    let btn = UIButton()
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    btn.setTitle("预览", for: .normal)
    btn.setTitleColor(UIColor.blue, for: .normal )
    return btn
  }()
  
  let commitBtn: UIButton = {
    let btn = UIButton()
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    btn.setTitle("完成", for: .normal)
    btn.setTitleColor(UIColor.blue, for: .normal )
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
    self.backgroundColor = UIColor.white
    addSubview(previewBtn)
    addSubview(commitBtn)
    previewBtn.translatesAutoresizingMaskIntoConstraints = false
    commitBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        previewBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10) ,
        previewBtn.topAnchor.constraint(equalTo: self.topAnchor) ,
        previewBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor ) ,
        previewBtn.widthAnchor.constraint(equalToConstant: 80) ,
        commitBtn.widthAnchor.constraint(equalToConstant: 80) ,
        commitBtn.topAnchor.constraint(equalTo: self.topAnchor) ,
        commitBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor ) ,
        commitBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
      ])
  }
}







