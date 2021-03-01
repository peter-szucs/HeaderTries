//
//  DetailViewController.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-03-01.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    private var scrollView = UIScrollView()
    private var headerView = UIView()
    private var headerTitleLabel = UILabel()
    private var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.text = "Header"
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        setupUI()
        scrollView.contentInset = UIEdgeInsets(top: 209, left: 0, bottom: 0, right: 0)
        scrollView.delegate = self
    }
    
    func setupUI() {
        headerView.addSubview(headerTitleLabel)
        scrollView.addSubview(headerView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.backgroundColor = .white
        headerView.backgroundColor = .cyan
        scrollView.backgroundColor = .red
        contentView.backgroundColor = .brown
        
        scrollView.snp.makeConstraints { (m) in
            m.top.equalTo(view.snp.top)
            m.bottom.equalTo(view.snp.bottom)
            m.width.equalTo(view.snp.width)
//            m.width.equalTo(UIScreen.main.bounds.width)
            m.centerX.equalTo(view.snp.centerX )
//            m.height.equalTo(UIScreen.main.bounds.height)
//            m.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { (m) in
            m.top.equalTo(view.snp.top)
            m.width.equalTo(scrollView.snp.width)
//            m.bottom.equalTo(contentView.snp.top)
            m.height.equalTo(300)
        }
        
        headerTitleLabel.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (m) in
            m.width.equalTo(scrollView.snp.width)
            m.bottom.equalTo(scrollView.snp.bottom)
            m.top.equalTo(headerView.snp.bottom)
            m.height.equalTo(800)
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = max(y, 91)
        print("!!! height: \(height)")
        if (height <= 300 && height >= 91) {
            print("!!! Updating Constraints")
            headerView.snp.updateConstraints { (m) in
                m.top.equalTo(view.snp.top)
                m.width.equalTo(scrollView.snp.width)
                m.height.equalTo(height)
            }
        }
        
        print("!!! y: \(y)")
    }
}
