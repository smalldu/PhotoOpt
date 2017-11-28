//
//  ViewController.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var choose: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    choose.addTarget(self, action: #selector(chooseClick), for: .touchUpInside)
  }
  
  @objc func chooseClick(){
    
    self.presentPhotos(3) { (items) in
      print("已选择 \(items.count) 张图片")
    }
    
  }
}























