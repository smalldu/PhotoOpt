//
//  PhotoCategoryController.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class PhotoCategoryController: UIViewController {
  
  let tableView: UITableView = {
    let tv = UITableView()
    tv.tableFooterView = UIView()
    
    return tv
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -tableView.contentSize.height)
    self.fadeIn()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    if tableView.contentSize.height < self.view.bounds.height - 20 && tableView.contentSize.height > 0{
      tableView.frame.size.height = tableView.contentSize.height + 10
    }
  }
  
}



// MARK: - setup

extension PhotoCategoryController {
  
  func layoutUI(){
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    view.addSubview(tableView)
    tableView.frame = view.bounds.insetBy(dx: 0, dy: 20).offsetBy(dx: 0, dy: -10)
//    tableView.backgroundColor = UIColor.clear
    tableView.delegate = self
    tableView.dataSource = self
  }
  func fadeIn(){
//    tableView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -tableView.contentSize.height)
    UIView.animate(withDuration: 0.3, animations: {
      self.tableView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  func fadeOut(){
//    self.tableView.transform = CGAffineTransform.identity
    UIView.animate(withDuration: 0.3, animations: {
      self.tableView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.tableView.contentSize.height)
    }, completion: nil)
  }
}


extension PhotoCategoryController: UITableViewDataSource,UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
}














