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
    let plc = PhotoListController()
    self.present(plc, animated: true, completion: nil)
  }
}

