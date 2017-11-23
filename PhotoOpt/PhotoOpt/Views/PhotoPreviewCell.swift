//
//  PhotoPreviewCell.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

protocol PhotoPreviewCellDelegate: class {
  func photoPreviewDidToggle(_ cell: PhotoPreviewCell)
}

class PhotoPreviewCell: UICollectionViewCell {
  static let reuseID = "\(PhotoPreviewCell.self)"
  var representedAssetIdentifier: String = ""
  weak var delegate: PhotoPreviewCellDelegate?
  
  @IBOutlet weak var content: UIImageView!
  @IBOutlet weak var selectBtn: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var thumbnailImage: UIImage? {
    didSet {
      content.image = thumbnailImage
    }
  }
  
  var isChoosed: Bool  = false{
    didSet{
      if isChoosed {
        selectBtn.tintColor = UIColor.blue
      }else{
        selectBtn.tintColor = UIColor.lightGray
      }
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    scrollView.maximumZoomScale = 3.0
    scrollView.minimumZoomScale = 1.0
    scrollView.delegate = self
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg))
    doubleTap.numberOfTouchesRequired = 1
    doubleTap.numberOfTapsRequired = 2
    self.content.addGestureRecognizer(doubleTap)
    self.content.isUserInteractionEnabled = true
    
    selectBtn.addTarget(self, action: #selector(selectButtonClick), for: .touchUpInside)
  }
  
  @objc func doubleTapImg(){
    if scrollView.zoomScale == 1.0 {
      UIView.animate(withDuration: 0.5, animations: {
        self.scrollView.zoomScale = 3.0
      })
    }else{
      UIView.animate(withDuration: 0.5, animations: {
        self.scrollView.zoomScale = 1.0
      })
    }
  }
  
  @objc func selectButtonClick(){
    delegate?.photoPreviewDidToggle(self)
  }
  
  func toggle(){
    isChoosed = !isChoosed
    self.selectBtn.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
    UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 0.6 , initialSpringVelocity: 20 , options: .curveEaseOut , animations: {
      self.selectBtn.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  
}


extension PhotoPreviewCell: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.content
  }

}













