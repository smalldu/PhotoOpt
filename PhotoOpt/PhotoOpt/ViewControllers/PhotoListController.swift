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
  
  lazy var btmView: UIView = {
    let view = PhotoBottomView()
    view.backgroundColor = UIColor.lightGray
    return view
  }()
  
  lazy var topView: UIView = {
    let view = PhotoTopView()
    view.backgroundColor = UIColor.lightGray
    return view
  }()
  
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
    layoutUI()
    
    for type in assetGroupTypes {
      let fetchResult = PHAssetCollection.fetchAssetCollections(with: collectionTypeForSubtype(type), subtype: type, options: nil)
      fetchResult.enumerateObjects({ (collection, index, stop) in
        print(collection.localIdentifier)
        print(collection.localizedTitle ?? "")
      })
    }
  }
  
}


// MARK: - layout
extension PhotoListController {
  func layoutUI(){
    view.addSubview(btmView)
    view.addConstraintsWith(formart: "H:|[v0]|", views: btmView)
    view.addConstraintsWith(formart: "V:[v0(80)]|", views: btmView)
    
    view.addSubview(topView)
    view.addConstraintsWith(formart: "H:|[v0]|", views: topView)
    view.addConstraintsWith(formart: "V:|[v0(64)]", views: topView)
    topView.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(clickTop))
    topView.addGestureRecognizer(tap)
  }
  
  @objc func clickTop(){
    self.dismiss(animated: true, completion: nil)
  }
  
}









