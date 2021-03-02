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
    private let contentTextLabel = UILabel()
    
    private let insetHeight: CGFloat = 209
    private let titleLabelLeftConstModifier: CGFloat = 0
    private let titleLabelBottomConstModifier: CGFloat = 0
    
    private let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer odio tortor, consectetur a molestie eu, malesuada sed lectus. Cras mattis tristique luctus. Aenean congue dui id mollis tempus. Nulla facilisi. Mauris in condimentum velit. Duis sollicitudin ornare molestie. Quisque lobortis imperdiet libero quis pellentesque. Nulla eu viverra odio, at ullamcorper urna. Donec vestibulum velit id erat venenatis, ac gravida tortor luctus. Nam pulvinar pulvinar nulla ac fringilla. Sed aliquam interdum lectus, eget dictum lacus aliquam in. Curabitur et ante venenatis, vulputate tellus at, pulvinar mi. Donec quis tellus arcu. Curabitur ultricies urna mauris, a pretium lectus consectetur at. Nunc tempor id sem sed volutpat. Vivamus faucibus faucibus nisi. Nulla vehicula lectus vel leo molestie hendrerit. Vivamus in finibus augue, eu tempus purus. Fusce fringilla ligula sit amet mollis feugiat. Nam varius pharetra facilisis. Fusce ultrices condimentum enim id faucibus. Aliquam ac enim at erat laoreet porttitor in a nunc. Vestibulum auctor dui quis vestibulum malesuada. Praesent vitae dignissim ante, eget consectetur nulla. Nam eleifend dapibus nulla at tristique. Phasellus laoreet diam lorem, quis ultricies risus venenatis sit amet. Curabitur ac mi feugiat, tempus odio sit amet, lacinia sapien. Suspendisse quis orci eu orci mollis condimentum. Pellentesque ex quam, ultrices et laoreet in, commodo sed risus. Proin bibendum varius tellus, sed euismod est hendrerit at. Integer congue sit amet ante sit amet ornare. Pellentesque nec pharetra purus. \n Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam tristique viverra quam, ac aliquet neque accumsan ac. Proin magna mi, finibus at imperdiet non, vehicula a ante. Etiam eros ipsum, sollicitudin quis fringilla vel, cursus in dui. Donec pretium nibh vel gravida finibus. Curabitur eleifend condimentum massa eget pellentesque. Duis convallis felis turpis, sed dapibus magna viverra et. Donec at purus ac nisl tincidunt semper. Aliquam non vestibulum est, eget ullamcorper nibh. Duis ut libero commodo nibh consequat faucibus. Morbi non ornare nunc. \n Nulla porttitor dignissim lacus id aliquet. Quisque ac ex ornare, finibus massa ut, ultrices tellus. Nunc mi mauris, eleifend quis ante non, vulputate eleifend urna. Ut porttitor maximus auctor. Morbi varius, massa et tincidunt pellentesque, turpis felis efficitur lectus, a vehicula lectus tortor id lorem. Donec a metus lectus. Sed in pretium eros, id suscipit enim. Donec ut ligula placerat, consectetur orci a, pellentesque mi. Nulla mollis leo vel scelerisque interdum. Sed id consequat lacus, et interdum est. Mauris non pretium lacus. Suspendisse sem eros, varius vel ante et, porttitor luctus nibh. Vestibulum justo metus, aliquet ac sapien ac, condimentum consectetur ligula. Curabitur ullamcorper, risus in tempus viverra, nibh turpis volutpat libero, non ornare est nibh ac elit. Vestibulum vestibulum, nunc in ultrices pellentesque, lectus arcu pellentesque quam, at aliquam lectus leo nec enim."

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.text = "Header"
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        setupUI()
        scrollView.contentInset = UIEdgeInsets(top: insetHeight, left: 0, bottom: 0, right: 0)
        scrollView.delegate = self
        contentTextLabel.text = dummyText
        contentTextLabel.numberOfLines = 0
        
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(headerView)
//        scrollView.addSubview(headerView)
        scrollView.addSubview(contentView)
        headerView.addSubview(headerTitleLabel)
        contentView.addSubview(contentTextLabel)
        
        view.backgroundColor = .white
        headerView.backgroundColor = .cyan
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .brown
        
        scrollView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { (m) in
//            m.top.equalTo(view.snp.top)
            m.top.left.right.equalToSuperview()
//            m.top.left.right.equalTo(view)
            m.height.equalTo(300)
        }
        
        headerTitleLabel.snp.makeConstraints { (m) in
            m.bottom.equalTo(headerView.snp.bottom).offset(-16)
            m.left.equalTo(headerView.snp.left).offset(100)
        }
        
        contentView.snp.makeConstraints { (m) in
//            m.top.equalTo(headerView.snp.bottom)
            m.top.bottom.equalToSuperview()
            m.left.right.equalTo(view)
        }
        
        contentTextLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(16)
            m.left.equalToSuperview().offset(16)
            m.right.equalToSuperview().offset(-16)
            m.bottom.equalToSuperview().offset(-44)
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        
        let height = max(y, 91)
//        print("!!! height: \(height)")
        if (height <= 300 && height >= 91) {
//            print("!!! Updating Constraints")
            let labelMedian =
            headerView.snp.updateConstraints { (m) in
                m.height.equalTo(height)
            }
            
        } else {
            headerView.snp.updateConstraints { (m) in
                m.height.equalTo(300)
            }
        }
        
        print("!!! y: \(y)")
    }
}
