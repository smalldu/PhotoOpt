//
//  PhotoCell.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

enum PhotoType: String {
  case live = "Live"
  case gif = "Gif"
  case normal
}
class PhotoCell: UICollectionViewCell {
  
  static let reuseID = "\(PhotoCell.self)"
  var representedAssetIdentifier: String = ""
  
  @IBOutlet weak var content: UIImageView!
  @IBOutlet weak var flag: UILabel!
  
  
  
  var type: PhotoType = .normal {
    didSet{
      if type == .normal {
        flag.isHidden = true
      } else {
        flag.isHidden = false
        flag.text = type.rawValue
      }
    }
  }
  
  var thumbnailImage: UIImage? {
    didSet {
      content.image = thumbnailImage
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    content.contentMode = .scaleAspectFill
    content.clipsToBounds = true
    
  }
  
}

