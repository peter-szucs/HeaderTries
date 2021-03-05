//
//  CustomPagingItem.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-03-05.
//

import UIKit
import Parchment

struct CustomPagingItem: PagingItem, Hashable, Comparable {

    let index: Int
    let labelText: String

    init(index: Int, text: String) {
        self.index = index
        self.labelText = text
    }

    static func < (lhs: CustomPagingItem, rhs: CustomPagingItem) -> Bool {
        return lhs.index < rhs.index
    }
}
