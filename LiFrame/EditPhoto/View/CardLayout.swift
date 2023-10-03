//
//  CardLayout.swift
//  LiFrame
//
//  Created by TingFeng Shen on 2023/10/2.
//

import Foundation
import UIKit
class CardLayout: UICollectionViewFlowLayout {
    private var collectionViewHeight: CGFloat {
      return collectionView!.frame.height
    }
    private var collectionViewWidth: CGFloat {
      return collectionView!.frame.width
    }
    
    private var cellWidth: CGFloat {
      return collectionViewWidth*0.7
    }
    
    private var cellMargin: CGFloat {
      return (collectionViewWidth - cellWidth)/7
    }
    // 内邊距
    private var margin: CGFloat {
      return (collectionViewWidth - cellWidth)/2
    }
    
  /// MARK: - 一些計算屬性，減少一些 code
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        minimumLineSpacing = cellMargin
        itemSize = CGSize(width: cellWidth, height: collectionViewHeight*0.75)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        // 1
        guard let visibleAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        // 2
        let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width/2
        for attribute in visibleAttributes {

          // 3
          let distance = abs(attribute.center.x - centerX)
          
          // 4
          let aprtScale = distance / collectionView.bounds.size.width

          // 5
          let scale = abs(cos(aprtScale * CGFloat(Double.pi/4)))
          attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        // 6
        return visibleAttributes
    }
    // 是否及時刷新佈局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
 
}
