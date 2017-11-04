//
//  PhotoListController+CacheAssets.swift
//  PhotoOpt
//
//  Created by Zoey Shi on 2017/11/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

private extension UICollectionView {
  func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
    let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
    return allLayoutAttributes.map { $0.indexPath }
  }
}

extension PhotoListController {
  
  func resetCachedAssets() {
    imageManager.stopCachingImagesForAllAssets()
    previousPreheatRect = .zero
  }
  
  
  func updateCachedAssets() {
    // Update only if the view is visible.
    guard isViewLoaded && view.window != nil else { return }
    guard let fetchResult = self.category?.result else { return }
    // The preheat window is twice the height of the visible rect.
    let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
    let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
    
    // Update only if the visible area is significantly different from the last preheated area.
    let delta = abs(preheatRect.midY - previousPreheatRect.midY)
    guard delta > view.bounds.height / 3 else { return }
    
    // Compute the assets to start caching and to stop caching.
    let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
    let addedAssets = addedRects
      .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
      .map { indexPath in fetchResult.object(at: indexPath.item) }
    let removedAssets = removedRects
      .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
      .map { indexPath in fetchResult.object(at: indexPath.item) }
    
    // Update the assets the PHCachingImageManager is caching.
    imageManager.startCachingImages(for: addedAssets,
                                    targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
    imageManager.stopCachingImages(for: removedAssets,
                                   targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
    
    // Store the preheat rect to compare against in the future.
    previousPreheatRect = preheatRect
  }
  
  fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
    if old.intersects(new) {
      var added = [CGRect]()
      if new.maxY > old.maxY {
        added += [CGRect(x: new.origin.x, y: old.maxY,
                         width: new.width, height: new.maxY - old.maxY)]
      }
      if old.minY > new.minY {
        added += [CGRect(x: new.origin.x, y: new.minY,
                         width: new.width, height: old.minY - new.minY)]
      }
      var removed = [CGRect]()
      if new.maxY < old.maxY {
        removed += [CGRect(x: new.origin.x, y: new.maxY,
                           width: new.width, height: old.maxY - new.maxY)]
      }
      if old.minY < new.minY {
        removed += [CGRect(x: new.origin.x, y: old.minY,
                           width: new.width, height: new.minY - old.minY)]
      }
      return (added, removed)
    } else {
      return ([new], [old])
    }
  }
  
}
