//
//  ViewController.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-02-22.
//

import UIKit
import SnapKit
import Parchment

var topViewInitialHeight: CGFloat = 150
let topViewFinalHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
let topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight

class ViewController: UIViewController {
    
    private var headerView = UIView()
    
    private var pagingViewController = PagingViewController()
    private let button = UIButton()
    
    private var buttonLeftConstraint: Constraint!
    private var buttonBottomConstraint: Constraint!
    
    private let labelStartOffset: CGFloat = 16
    private var labelEndOffset: CGFloat = 0
    private let labelStartBottomOffset: CGFloat = 16
    private var labelEndBottomOffset: CGFloat = 8
    
    private var pages = [UIViewController?].init(repeating: nil, count: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -topViewFinalHeight)
        
        button.setTitle("No Header", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        pagingViewController.dataSource = self
        pagingViewController.register(PagingCustomCell.self, for: CustomPagingItem.self)
        addChild(pagingViewController)
        pagingViewController.borderOptions = .hidden
        pagingViewController.menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        pagingViewController.indicatorClass = CustomIndicatorView.self
        pagingViewController.indicatorOptions = .visible(
            height: 32,
            zIndex: -1,
            spacing: .zero,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        )
        pagingViewController.indicatorColor = .purple
        pagingViewController.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let headerViewWidth = headerView.bounds.size.width
        let labelViewWidth = button.bounds.size.width
        
        labelEndOffset = (headerViewWidth / 2) - (labelViewWidth / 2)
        
        addPanGestureToTopViewAndCollectionView()
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
        addShadowToHeader()
        view.backgroundColor = .white
        headerView.layer.zPosition = 1000
        headerView.addSubview(button)
        view.addSubview(headerView)
        view.addSubview(pagingViewController.view)
        pagingViewController.backgroundColor = .clear
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.backgroundColor = .white
        
        headerView.snp.makeConstraints { (m) in
            m.top.left.right.equalToSuperview()
            m.height.equalTo(topViewInitialHeight)
        }
        
        button.snp.makeConstraints { (m) in
            buttonLeftConstraint = m.left.equalToSuperview().offset(16).constraint
            buttonBottomConstraint = m.bottom.equalToSuperview().offset(-16).constraint
        }
        
        pagingViewController.view.snp.makeConstraints { (m) in
            m.top.equalTo(headerView.snp.bottom)
            m.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func addShadowToHeader() {
        pagingViewController.collectionView.layer.masksToBounds = true
        pagingViewController.collectionView.layer.shadowOffset = CGSize(width: 0, height: 1)
        pagingViewController.collectionView.layer.shadowRadius = 1
        pagingViewController.collectionView.layer.shadowOpacity = 0.3
        
    }
    
    func addPanGestureToTopViewAndCollectionView() {
            
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
        
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(topViewPanGesture)
        
        // Adding pan gesture to collection view is overriding the collection view scroll.
        
        // TODO: - Check to see if possibility to put this into topViewMoved instead. using collectionviews
        //         integrated gesturerecognizer to differentiate
//        pagingViewController.collectionView.isUserInteractionEnabled = true
//        pagingViewController.collectionView.addGestureRecognizer(topViewPanGesture)
        
    }
    var dragInitialY: CGFloat = 0
    var dragPreviousY: CGFloat = 0
    var dragDirection: DragDirection = .Up
    
    @objc func topViewMoved(_ gesture: UIPanGestureRecognizer) {
        
        // --- Implement gesture of collectionview --
        
//        pagingViewController.collectionView.gestureRecognizers
        
        // ------------------------------------------
        
        var dragYDiff : CGFloat
        
        
        switch gesture.state {
        
        case .began:
            
            dragInitialY = gesture.location(in: self.view).y
            dragPreviousY = dragInitialY
            print("--- Drag Began, initY: \(dragInitialY)")
            
        case .changed:
            
            let dragCurrentY = gesture.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            dragDirection = dragYDiff < 0 ? .Down : .Up
            innerTableViewDidScroll(withDistance: dragYDiff)
            print("--- Drag changed, dragYDiff: \(dragYDiff)")
            
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
        return CustomPagingItem(index: index, text: "View \(index+1)")
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
        
        if (finalHeight == topViewFinalHeight) {
            print("!!! adding shadow")
            pagingViewController.collectionView.layer.masksToBounds = false
        } else if (finalHeight > topViewFinalHeight) {
            print("!!! removing shadow")
            pagingViewController.collectionView.layer.masksToBounds = true
        }
        
        if (currentHeight != finalHeight) {
            headerView.snp.updateConstraints { (m) in
//                print("---")
//                print("!!! ViewController updating headerView constraints New Height = \(finalHeight)")
//                print("---")
                m.height.equalTo(finalHeight)
            }
            
            let ratio = (finalHeight - topViewFinalHeight) / (topViewInitialHeight - topViewFinalHeight)
            
            let leftDiff = (labelEndOffset - labelStartOffset) * ratio
            let bottomDiff = (labelEndBottomOffset - labelStartBottomOffset) * ratio
            
            buttonLeftConstraint.update(offset: labelEndOffset - leftDiff)
            buttonBottomConstraint.update(offset: bottomDiff - labelEndBottomOffset)
            
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
        buttonBottomConstraint.update(offset: -labelStartBottomOffset)

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
        buttonBottomConstraint.update(offset: -labelEndBottomOffset)

        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.view.layoutIfNeeded()
        })
    }

}
