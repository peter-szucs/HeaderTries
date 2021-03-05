//
//  PagingCustomCell.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-03-04.
//

import UIKit
import Parchment
import SnapKit

class PagingCustomCell: PagingCell {
    
//    private var options: PagingOptions?
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        label.frame = CGRect(x: 0, y: insets.top, width: contentView.bounds.width + insets.left + insets.right, height: contentView.bounds.midY - insets.bottom)
        
    }
    
    open func configure() {
//        label.backgroundColor = .white
        label.textAlignment = .center
        contentView.addSubview(label)
        contentView.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { (m) in
//            m.edges.equalToSuperview()
            m.left.equalToSuperview().offset(16)
            m.top.equalToSuperview().offset(8)
            m.right.equalToSuperview().offset(-16)
            m.bottom.equalToSuperview().offset(-8)
        }
    }
    
    fileprivate func updateSelectedState(selected: Bool) {
        if selected {
            label.textColor = .white
        } else {
            label.textColor = .black
        }
    }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        let customPagingItem = pagingItem as! CustomPagingItem
        label.text = customPagingItem.labelText
        
        updateSelectedState(selected: selected)
    }
}
