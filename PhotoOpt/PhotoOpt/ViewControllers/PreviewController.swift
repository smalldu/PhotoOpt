//
//  PreviewController.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

class PreviewController: UIViewController {
  
  let result:PHFetchResult<PHAsset>
  init(result:PHFetchResult<PHAsset>) {
    self.result = result
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let imageManager = PHCachingImageManager()
  
  lazy var btmView: PhotoPreviewBottomView = {
    let view = PhotoPreviewBottomView()
    view.backgroundColor = UIColor.cf8f8f8
    return view
  }()
  
  lazy var layout: UICollectionViewFlowLayout = {
    let lt = UICollectionViewFlowLayout()
    lt.scrollDirection = .horizontal
    lt.itemSize = self.view.bounds.size
    lt.minimumInteritemSpacing = 0
    lt.minimumLineSpacing = 0
    return lt
  }()
  
  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame:self.view.bounds, collectionViewLayout: self.layout)
    cv.backgroundColor = UIColor.white
    cv.register(UINib(nibName: PhotoPreviewCell.reuseID, bundle: Bundle.main), forCellWithReuseIdentifier: PhotoPreviewCell.reuseID)
    cv.backgroundColor = UIColor.black
    cv.alwaysBounceHorizontal = true
    cv.isPagingEnabled = true
    cv.showsHorizontalScrollIndicator = false
    return cv
  }()
  
  var thumbnailSize: CGSize = .zero
  override func viewDidLoad() {
    super.viewDidLoad()
    let scale = UIScreen.main.scale
    automaticallyAdjustsScrollViewInsets = false
    thumbnailSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
    view.addSubview(collectionView)
    view.addSubview(btmView)
    btmView.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    btmView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      btmView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor) ,
      btmView.leftAnchor.constraint(equalTo: self.view.leftAnchor) ,
      btmView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      btmView.heightAnchor.constraint(equalToConstant: 49)
    ])
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
}



// MARK: - UICollectionViewDataSource,UICollectionViewDelegate

extension PreviewController: UICollectionViewDataSource,UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPreviewCell.reuseID, for: indexPath) as! PhotoPreviewCell
    let asset = result.object(at: indexPath.row)
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.isChoosed = SelectedAssetManager.shared.contains(asset)
    imageManager.requestImage(for: asset , targetSize: self.thumbnailSize , contentMode: .aspectFill , options: nil) { (image, info ) in
      if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
        cell.thumbnailImage = image
      }
    }
    cell.delegate = self
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return result.count
  }
}


extension PreviewController: PhotoPreviewBottomDelegate , PhotoPreviewCellDelegate{
  
  func photoPreviewDidToggle(_ cell: PhotoPreviewCell) {
    // FIXME: max count
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    let asset = result.object(at: indexPath.row)
    SelectedAssetManager.shared.toggle(asset, image: cell.thumbnailImage)
    cell.toggle()
  }
  
  func photoPreviewBottomViewDidBack(_ view: PhotoPreviewBottomView) {
    self.navigationController?.popViewController(animated: true)
  }
  func photoPreviewBottomViewDidComplete(_ view: PhotoPreviewBottomView) {
  }
  
}





