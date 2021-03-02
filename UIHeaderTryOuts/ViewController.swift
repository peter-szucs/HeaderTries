//
//  ViewController.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-02-22.
//

import UIKit
import SnapKit
import Parchment

var topViewInitialHeight: CGFloat = 250
let topViewFinalHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
let topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight

class ViewController: UIViewController {
    
    private var headerView = UIView()
    
    private var pagingViewController = PagingViewController()
    private let button = UIButton()
    
    private var buttonLeftConstraint: Constraint!
    
    private let labelStartOffset: CGFloat = 16
    private var labelEndOffset: CGFloat = 0
    
    private var pages = [UIViewController?].init(repeating: nil, count: 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -topViewFinalHeight)
        
        button.setTitle("No Header", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        pagingViewController.dataSource = self
        addChild(pagingViewController)
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let headerViewWidth = headerView.bounds.size.width
        let labelViewWidth = button.bounds.size.width
        
        labelEndOffset = (headerViewWidth / 2) - (labelViewWidth / 2)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("!!! Button tapped")
        let navVC = NavBarViewController()
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(navVC, animated: true)
        self.view.bringSubviewToFront(button)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        headerView.layer.zPosition = 1000
        headerView.addSubview(button)
        view.addSubview(headerView)
        view.addSubview(pagingViewController.view)
        pagingViewController.backgroundColor = .brown
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.backgroundColor = .orange
        
        headerView.snp.makeConstraints { (m) in
            m.top.left.right.equalToSuperview()
            m.height.equalTo(topViewInitialHeight)
        }
        
        button.snp.makeConstraints { (m) in
            buttonLeftConstraint = m.left.equalToSuperview().offset(16).constraint
            m.bottom.equalToSuperview().offset(-16)
        }
        
        pagingViewController.view.snp.makeConstraints { (m) in
            m.top.equalTo(headerView.snp.bottom)
            m.left.right.bottom.equalToSuperview()
        }
    }
    
    func addPanGestureToTopViewAndCollectionView() {
            
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
        
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(topViewPanGesture)
        
        /* Adding pan gesture to collection view is overriding the collection view scroll.
         
         let collViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
         
         tabBarCollectionView.isUserInteractionEnabled = true
         tabBarCollectionView.addGestureRecognizer(collViewPanGesture)
         
         */
    }
    var dragInitialY: CGFloat = 0
    var dragPreviousY: CGFloat = 0
    var dragDirection: DragDirection = .Up
    
    @objc func topViewMoved(_ gesture: UIPanGestureRecognizer) {
        
        var dragYDiff : CGFloat
        
        switch gesture.state {
        
        case .began:
            
            dragInitialY = gesture.location(in: self.view).y
            dragPreviousY = dragInitialY
            
        case .changed:
            
            let dragCurrentY = gesture.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            dragDirection = dragYDiff < 0 ? .Down : .Up
            innerTableViewDidScroll(withDistance: dragYDiff)
            
        case .ended:
            
            innerTableViewScrollEnded(withScrollDirection: dragDirection)
            
        default: return
            
        }
    }
}

extension ViewController: PagingViewControllerDataSource {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return pages.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let currentVc = pages[index]
        
        if let currentVc = currentVc {
            return currentVc
        } else {
            let tableViewVC = TableViewController()
            tableViewVC.innerTableViewScrollDelegate = self
            
            pages[index] = tableViewVC
            
            return tableViewVC
        }
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: "View \(index+1)")
    }
    
    
}
//MARK:- Sticky Header Effect
extension ViewController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        return headerView.bounds.size.height
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        let currentHeight = currentHeaderHeight
        
        let newHeight = currentHeight - scrollDistance
        
        let finalHeight: CGFloat
        
        if (newHeight >= topViewFinalHeight && newHeight <= topViewInitialHeight) {
            finalHeight = newHeight
        } else if (newHeight < topViewFinalHeight) {
            finalHeight = topViewFinalHeight
        } else if (newHeight > topViewInitialHeight) {
            finalHeight = topViewInitialHeight
        } else {
            finalHeight = currentHeight
        }
        
        if (currentHeight != finalHeight) {
            headerView.snp.updateConstraints { (m) in
                print("---")
                print("!!! ViewController updating headerView constraints New Height = \(finalHeight)")
                print("---")
                m.height.equalTo(finalHeight)
            }
            
            let ratio = (finalHeight - topViewFinalHeight) / (topViewInitialHeight - topViewFinalHeight)
            
            let diff = (labelEndOffset - labelStartOffset) * ratio
            
            buttonLeftConstraint.update(offset: labelEndOffset - diff)
            
            
            self.view.updateConstraints()
        }
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = currentHeaderHeight

        /*
         *  Scroll is not restricted.
         *  So this check might cause the view to get stuck in the header height is greater than initial height.
         */
        if topViewHeight >= topViewInitialHeight || topViewHeight <= topViewFinalHeight { return }

        if topViewHeight <= topViewFinalHeight + 20 {

            scrollToFinalView()

        } else if topViewHeight <= topViewInitialHeight - 20 {

            switch scrollDirection {

            case .Down: scrollToInitialView()
            case .Up: scrollToFinalView()

            }

        } else {

            scrollToInitialView()
        }
    }
    
    func scrollToInitialView() {

        let topViewCurrentHeight = headerView.frame.height

        let distanceToBeMoved = abs(topViewCurrentHeight - topViewInitialHeight)

        var time = distanceToBeMoved / 500

        if time < 0.25 {

            time = 0.25
        }
        
        headerView.snp.updateConstraints { (m) in
            m.height.equalTo(topViewInitialHeight)
        }
        
        buttonLeftConstraint.update(offset: labelStartOffset)

        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.view.layoutIfNeeded()
        })
    }

    func scrollToFinalView() {

        let topViewCurrentHeight = headerView.frame.height

        let distanceToBeMoved = abs(topViewCurrentHeight - topViewFinalHeight)

        var time = distanceToBeMoved / 500

        if time < 0.25 {

            time = 0.25
        }
        
        headerView.snp.updateConstraints { (m) in
            m.height.equalTo(topViewFinalHeight)
        }
        
        buttonLeftConstraint.update(offset: labelEndOffset)

        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.view.layoutIfNeeded()
        })
    }

}
