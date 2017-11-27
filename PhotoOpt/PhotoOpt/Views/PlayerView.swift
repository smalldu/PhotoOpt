//
//  PlayerView.swift
//  PhotoOpt
//
//  Created by duzhe on 2017/11/25.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: class {
  func livePlayDidFinish(_ view: PlayerView)
  func livePlayDidStop(_ view: PlayerView)
  func livePlayDidBegin(_ view: PlayerView)
}

// TODO: - 结束要销毁
class Player {
  static let shared = Player()
  var currentPlayer: AVPlayer?
  var maxCount: Int = 5 // 最大12个元素
  var currentIndex: Int = 0
  var playerPool: [AVPlayer] = []
  
  func player()->AVPlayer{
    currentPlayer?.pause()
    if currentPlayer == nil {
      let avplayer = AVPlayer()
      currentPlayer = avplayer
    }
//    if playerPool.count < maxCount {
//      playerPool.append(avplayer)
//    }
//    let index = currentIndex
//    if currentIndex == maxCount - 1{
//      currentIndex = 0
//    }
//    currentIndex += 1
    return currentPlayer!
  }
}

class PlayerView: UIView {
  
  weak var delegate: PlayerViewDelegate?
  var isFillContent = true
  var avplayer: AVPlayer?
  var avItem: AVPlayerItem?
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareView()
  }
  
  func prepareView(){
    NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlay(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: avItem)
    NotificationCenter.default.addObserver(self, selector: #selector(stopPlay(_:)), name: NSNotification.Name.kStopPlay , object: avItem)
  }
  var url: URL?
  
  func configWithURL(_ url: URL) {
    self.url = url
    self.avItem = AVPlayerItem(url: url)
  }
  @objc func stopPlay(_ notification: NSNotification){
    // 结束播放
    delegate?.livePlayDidStop(self)
  }
  
  @objc func didFinishPlay(_ notification: NSNotification){
    if let item = notification.object as? AVPlayerItem{
      if item == self.avItem{
        item.seek(to: kCMTimeZero)
        print("播放结束")
        delegate?.livePlayDidFinish(self)
      }
    }
  }
  
  func play() {
    if let playerLayer = self.layer as? AVPlayerLayer{
      avItem?.seek(to: kCMTimeZero)
      if self.avplayer == nil {
        self.avplayer = Player.shared.player()
      }
      if self.avplayer?.currentItem != avItem {
        self.avplayer?.replaceCurrentItem(with: avItem!)
      }
      // 停止所有播放
      NotificationCenter.default.post(name: NSNotification.Name.kStopPlay, object: nil)
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      playerLayer.player = avplayer
      if isFillContent {
        playerLayer.videoGravity = .resizeAspectFill
      }else{
        playerLayer.videoGravity = .resizeAspect
      }
      playerLayer.contentsScale = UIScreen.main.scale
      CATransaction.commit()
      avplayer?.play()
//      Double(Int64(time * Double(NSEC_PER_SEC))
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 , execute: { [weak self] in
        guard let `self` = self else{ return }
        self.delegate?.livePlayDidBegin(self)
      })
      
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
