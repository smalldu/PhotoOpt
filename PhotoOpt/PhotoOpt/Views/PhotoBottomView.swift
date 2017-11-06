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
    btn.backgroundColor = UIColor.blue
    return btn
  }()
  
  let commitBtn: UIButton = {
    let btn = UIButton()
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    btn.setTitle("完成", for: .normal)
    btn.backgroundColor = UIColor.blue
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
  }
}
