//
//  PHAsset+exts.swift
//  KeychainAccess
//
//  Created by duzhe on 2017/9/29.
//

import UIKit
import Photos

extension PHAsset {
  
  /// 是否为gif
  var isGIF: Bool {
    if let resource = PHAssetResource.assetResources(for: self).first{
      return resource.originalFilename.uppercased().hasSuffix("GIF")
    }
    return false
  }
  
}
