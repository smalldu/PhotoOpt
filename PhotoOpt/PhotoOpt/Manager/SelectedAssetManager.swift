//
//  SelectedAssetManager.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/17.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

class SelectedAssetManager{
  
  static let shared = SelectedAssetManager()
  var items: [AssetItem] = []
  
  var selectedCount: Int {
    return self.items.count
  }
  
  func register(){
    self.items.removeAll()
  }
  
  func toggle(_ item: PHAsset , image: UIImage? ,type: PhotoType? , movURL: URL? ) {
    let assets = items.map{ $0.asset }
    if assets.contains(item) {
      if let index = assets.index(where: { $0 == item }){
        items.remove(at: index)
      }
    }else{
      // 添加到 Items
      let assetItem = AssetItem(asset: item)
      assetItem.image = image
      assetItem.type = type
      assetItem.movURL = movURL
      assetItem.request()
      items.append(assetItem)
    }
  }
  
  func contains(_ item: PHAsset) -> Bool{
    let assets = items.map{ $0.asset }
    return assets.contains(item)
  }
  
}





