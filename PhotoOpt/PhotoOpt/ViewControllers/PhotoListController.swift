//
//  PhotoListController.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

class PhotoListController: UIViewController {
  
  public var assetGroupTypes: [PHAssetCollectionSubtype] = [
          .smartAlbumUserLibrary,
          .smartAlbumFavorites,
          .smartAlbumRecentlyAdded,
          .smartAlbumPanoramas,
          .smartAlbumScreenshots,
          .albumRegular
        ]
  private func collectionTypeForSubtype(_ subtype: PHAssetCollectionSubtype) -> PHAssetCollectionType {
    return subtype.rawValue < PHAssetCollectionSubtype.smartAlbumGeneric.rawValue ? .album : .smartAlbum
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    for type in assetGroupTypes {
      let fetchResult = PHAssetCollection.fetchAssetCollections(with: collectionTypeForSubtype(type), subtype: type, options: nil)
      fetchResult.enumerateObjects({ (collection, index, stop) in
        print(collection.localIdentifier)
        print(collection.localizedTitle)
      })
    }
  }
  
}

