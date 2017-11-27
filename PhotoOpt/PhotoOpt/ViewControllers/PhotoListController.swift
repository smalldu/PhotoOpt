//
//  PhotoListController.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

let sw: CGFloat = UIScreen.main.bounds.width
let sh: CGFloat = UIScreen.main.bounds.height


struct PhotoListCache {
  var image: UIImage?
  var movData: Data?
  var movURL: URL?
  var gifImage: UIImage?
}

class PhotoListController: UIViewController {
  
  enum State {
    case modeling // 正在 选择相册
    case normal
  }
  
  var photoCache: [PHAsset: PhotoListCache] = [:]
  
  /// 最大可选择数量
  public var maxSelectedCount: Int = 9
  
  lazy var categoryVC: PhotoCategoryController = {
    let vc = PhotoCategoryController(assetCategorys: self.assetManager.categorys)
    return vc
  }()
  
  var isAnimating = false
  
  lazy var btmView: PhotoBottomView = {
    let view = PhotoBottomView()
    view.backgroundColor = UIColor.cf8f8f8
    return view
  }()
  
  lazy var cancelItemBar: UIBarButtonItem = {
    let barItem = UIBarButtonItem(title: "取消", style: .plain , target: self , action: #selector(clickCancel))
    return barItem
  }()
  
  let layout: UICollectionViewFlowLayout = {
    let lt = UICollectionViewFlowLayout()
    return lt
  }()
  
  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
    cv.backgroundColor = UIColor.white
    cv.register(UINib(nibName: PhotoCell.reuseID, bundle: Bundle.main), forCellWithReuseIdentifier: PhotoCell.reuseID)
    cv.alwaysBounceVertical = true
    return cv
  }()
  lazy var fileManager = FileManager()
  let assetManager = AssetManager()
  let imageManager = PHCachingImageManager()
  var thumbnailSize: CGSize = CGSize.zero
  var previousPreheatRect = CGRect.zero
  
  let topTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    return label
  }()
  
  let subTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 11)
    label.textAlignment = .center
    label.textColor = UIColor.gray
    return label
  }()
  
  let angel: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "angel")
    imageView.contentMode = .center
    return imageView
  }()
  
  let topView: UIView = {
    let view = UIView()
    return view
  }()
  
  var state = State.normal
  var category: AssetCategory?
  var complete: (([AssetItem])->())?
  
  func completeHandler(_ complete: (([AssetItem])->())?){
    self.complete = complete
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    SelectedAssetManager.shared.register()
    resetCachedAssets()
    layoutUI()
    setupData()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateItemSize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateItemSize()
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.collectionView.reloadData()
    self.btmView.changeSelectedCount()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateCachedAssets()
  }
  
  /// 更新size
  private func updateItemSize() {
    let viewWidth = view.bounds.size.width
    let desiredItemWidth: CGFloat = 100
    let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 4)
    let padding: CGFloat = 1
    let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
    let itemSize = CGSize(width: itemWidth, height: itemWidth)
    layout.itemSize = itemSize
    layout.minimumInteritemSpacing = padding
    layout.minimumLineSpacing = padding
    let scale = UIScreen.main.scale
    thumbnailSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
  }
  
  deinit {
    Player.shared.currentPlayer = nil  // 销毁
    print("PhotoListController 已销毁")
  }
}

// MARK: - layout
extension PhotoListController {
  func layoutUI(){
    navigationItem.leftBarButtonItem = cancelItemBar
    btmView.delegate = self
    view.addSubview(btmView)
    view.addSubview(collectionView)
    view.addConstraintsWith(formart: "H:|[v0]|", views: btmView)
    view.addConstraintsWith(formart: "H:|[v0]|", views: collectionView)
    view.addConstraintsWith(formart: "V:|[v0][v1(49)]|", views: collectionView,btmView)
    setupTitleView()
    collectionView.delegate = self
    collectionView.dataSource = self
    self.assetManager.fetchOthers()
  }
  
  /// 配置 title
  func setupTitleView(){
    topView.frame = CGRect(x: 0, y: 0, width: 220, height: 50)
    navigationItem.titleView = topView
    topTitle.text = "所有照片"
    topTitle.frame = CGRect(x: 0, y: 4, width: 220, height: 20)
    topView.addSubview(topTitle)
    subTitle.text = "点击切换相册"
    subTitle.frame = CGRect(x: 0, y: 22, width: 220, height: 18)
    topView.addSubview(subTitle)
    let x = topView.bounds.midX + 35
    angel.frame = CGRect(x: x, y: 22, width: 18, height: 18)
    topView.addSubview(angel)
    let tapTitle = UITapGestureRecognizer(target: self, action: #selector(clickTitle))
    topView.addGestureRecognizer(tapTitle)
  }
  
  func setupData(){
    self.category = assetManager.firstCategory
  }
  
  @objc func clickCancel(){
    self.dismiss(animated: true, completion: nil)
  }
}










