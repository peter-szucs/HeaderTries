//
//  TableViewCell.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-02-22.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    var containerView = UIView()
    var titleLabel = UILabel()
    var icon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("____ TableViewCell: init called")
        
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(title: String) {
        print("____ TableViewCell: setCell called for: ", title)
        
        titleLabel.text = title
        icon.image = #imageLiteral(resourceName: "profile")
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 19
        icon.contentMode = .scaleAspectFill
        
    }
    
    func setupConstraints() {
        
        icon.snp.makeConstraints { (m) in
            m.height.width.equalTo(38)
            m.left.equalToSuperview().offset(16)
            m.top.equalToSuperview().offset(16)
            m.bottom.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.left.equalTo(icon.snp.right).offset(16)
        }
    }
}


