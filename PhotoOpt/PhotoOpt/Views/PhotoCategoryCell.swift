//
//  PhotoCategoryCell.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/4.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class PhotoCategoryCell: UITableViewCell {
  
  static let reuseID = "\(PhotoCategoryCell.self)"
  var representedAssetIdentifier: String = ""
  
  @IBOutlet weak var leftImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var countLabel: UILabel!
  
  var count: Int = 0{
    didSet{
      countLabel.text = "\(count)"
    }
  }
  var name: String = ""{
    didSet{
      nameLabel.text = name
    }
  }
  var thumbnailImage: UIImage? {
    didSet {
      leftImageView.image = thumbnailImage
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    countLabel.textColor = UIColor.gray
    leftImageView.contentMode = .scaleAspectFill
    leftImageView.clipsToBounds = true
  }
  
}

