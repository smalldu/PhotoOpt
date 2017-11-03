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
    let nav = UINavigationController(rootViewController: plc)
    self.present(nav, animated: true, completion: nil)
  }
}

