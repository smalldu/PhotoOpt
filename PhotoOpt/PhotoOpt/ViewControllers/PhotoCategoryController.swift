//
//  PhotoCategoryController.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

protocol PhotoCategoryDelegate: class {
  func categoryDidSelected(_ controller: PhotoCategoryController,category:AssetCategory)
}

class PhotoCategoryController: UIViewController {
  
  var assetCategorys: [AssetCategory] {
    didSet{
      realCategoryAssets = assetCategorys.filter{ ($0.count ?? 0) > 0 }
    }
  }
  fileprivate var realCategoryAssets: [AssetCategory] = []
  let imageManager = PHCachingImageManager()
  weak var delegate: PhotoCategoryDelegate?
  
  let tableView: UITableView = {
    let tv = UITableView()
    tv.tableFooterView = UIView()
    tv.rowHeight = 75
    tv.register(UINib(nibName: PhotoCategoryCell.reuseID, bundle: Bundle.main), forCellReuseIdentifier: PhotoCategoryCell.reuseID)
    return tv
  }()
  
  init(assetCategorys: [AssetCategory]) {
    self.assetCategorys = assetCategorys
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    if #available(iOS 11, *) {
      if tableView.contentSize.height + self.view.safeAreaInsets.top < self.view.bounds.height - 20 && tableView.contentSize.height > 0{
        tableView.frame.size.height = tableView.contentSize.height + self.view.safeAreaInsets.top
      }
    }else{
      if tableView.contentSize.height < self.view.bounds.height - 20 && tableView.contentSize.height > 0{
        tableView.frame.size.height = tableView.contentSize.height
      }
    }
  }
}

// MARK: - setup

extension PhotoCategoryController {
  
  func layoutUI(){
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    view.addSubview(tableView)
    tableView.frame = view.bounds.insetBy(dx: 0, dy: 20).offsetBy(dx: 0, dy: -10)
    tableView.delegate = self
    tableView.dataSource = self
  }
  func fadeIn(){
    UIView.animate(withDuration: 0.3, animations: {
      self.tableView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  func fadeOut(){
    UIView.animate(withDuration: 0.3, animations: {
      self.tableView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.tableView.contentSize.height)
    }, completion: nil)
  }
}


extension PhotoCategoryController: UITableViewDataSource,UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCategoryCell.reuseID, for: indexPath) as! PhotoCategoryCell
    let category = realCategoryAssets[indexPath.row]
    cell.count = category.count ?? 0
    cell.name = category.title ?? ""
    if let asset = category.result?.firstObject {
      cell.representedAssetIdentifier = asset.localIdentifier
      imageManager.requestImage(for: asset , targetSize: CGSize(width: 50, height: 50) , contentMode: .aspectFill , options: nil) { (image, info ) in
        if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
          cell.thumbnailImage = image
        }
      }
    }
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return realCategoryAssets.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let category = realCategoryAssets[indexPath.row]
    delegate?.categoryDidSelected(self, category: category)
  }
}














