//
//  CustomIndicatorView.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-03-05.
//

import UIKit
import Parchment

class CustomIndicatorView: PagingIndicatorView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layer.cornerRadius = layoutAttributes.bounds.height / 2
        layer.masksToBounds = true
    }
}
