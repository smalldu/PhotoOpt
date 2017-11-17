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
  var selectedAssets: [PHAsset] = []
  
  func toggle(_ item: PHAsset) {
    if selectedAssets.contains(item) {
      if let index = selectedAssets.index(where: { $0 == item }){
        selectedAssets.remove(at: index)
      }
    }else{
      selectedAssets.append(item)
    }
  }
  
  func contains(_ item: PHAsset) -> Bool{
    return self.selectedAssets.contains(item)
  }
  
}





