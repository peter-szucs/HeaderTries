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
    
    private let headerViewInitialHeight: CGFloat = 300
    private let headerViewFinalHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
    private let insetHeight: CGFloat = 209
    private var labelLeftConstraint: Constraint!
    private var labelBottomConstraint: Constraint!
    
    private let labelLeftStartOffset: CGFloat = 16
    private var labelLeftEndOffset: CGFloat = 0
    private var labelStartBottomOffset: CGFloat = 16
    private var labelEndBottomOffset: CGFloat = 8
    
    
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
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let headerViewWidth = headerView.bounds.size.width
        let labelViewWidth = headerTitleLabel.bounds.size.width
        
        labelLeftEndOffset = (headerViewWidth / 2) - (labelViewWidth / 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -91)
    }
    
    func setupUI() {
        addShadowToHeader()

        view.addSubview(scrollView)
        view.addSubview(headerView)
//        scrollView.addSubview(headerView)
        scrollView.addSubview(contentView)
        headerView.addSubview(headerTitleLabel)
        contentView.addSubview(contentTextLabel)
        
        view.backgroundColor = .white
        headerView.backgroundColor = .white
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .white
        
        scrollView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { (m) in
//            m.top.equalTo(view.snp.top)
            m.top.left.right.equalToSuperview()
//            m.top.left.right.equalTo(view)
            m.height.equalTo(headerViewInitialHeight)
        }
        
        headerTitleLabel.snp.makeConstraints { (m) in
            labelBottomConstraint = m.bottom.equalTo(headerView.snp.bottom).offset(labelStartBottomOffset).constraint
            labelLeftConstraint = m.left.equalTo(headerView.snp.left).offset(-labelLeftStartOffset).constraint
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
    
    var currentHeaderHeight: CGFloat {
        return headerView.bounds.size.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var currentHeight = currentHeaderHeight
        var oldContentOffset = CGPoint.zero
        let scrollDistance = scrollView.contentOffset.y - oldContentOffset.y
        let y = -scrollView.contentOffset.y
        let newHeight = currentHeight - scrollDistance
        
        let height = max(y, 91)
//        print("!!! height: \(height)")
        if (height <= 300 && height >= 91) {
//            print("!!! Updating Constraints")
            headerView.snp.updateConstraints { (m) in
                m.height.equalTo(height)
            }
            
            let ratio = (height - headerViewFinalHeight) / (headerViewInitialHeight - headerViewFinalHeight)
            
            let leftDiff = (labelLeftEndOffset - labelLeftStartOffset) * ratio
            let bottomDiff = (labelEndBottomOffset - labelStartBottomOffset) * ratio
            
            labelLeftConstraint.update(offset: labelLeftEndOffset - leftDiff)
            labelBottomConstraint.update(offset: bottomDiff - labelEndBottomOffset)
            if headerView.bounds.size.height == 91 {
                headerView.layer.masksToBounds = false
            } else {
                headerView.layer.masksToBounds = true
            }
            
        } else {
            headerView.snp.updateConstraints { (m) in
                m.height.equalTo(headerViewInitialHeight)
            }
            labelLeftConstraint.update(offset: labelLeftStartOffset)
            labelBottomConstraint.update(offset: labelStartBottomOffset)
        }
        
        print("!!! y: \(y)")
        self.view.updateConstraints()
    }
    
    func addShadowToHeader() {
        headerView.layer.masksToBounds = true
        headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.3
    }
}
