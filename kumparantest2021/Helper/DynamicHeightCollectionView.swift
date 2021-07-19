//
//  DynamicHeightCollectionView.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit
class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
