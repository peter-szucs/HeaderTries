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

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let firstViewController = TableViewController()
//        let secondViewController = UIViewController()
//        pagingViewController = PagingViewController(viewControllers: [firstViewController, secondViewController])
        
        button.setTitle("No Header", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        pagingViewController.dataSource = self
        addChild(pagingViewController)
        
        setupUI()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(didScroll), name: Notification.Name("delta"), object: nil)
//        populateBottomView()
    }
    
//    @objc func didScroll(notification: NSNotification) {
//        guard let delta = (notification.userInfo?["deltaNumber"] as? CGFloat) else { return }
//        let deltaConstraint = delta as? Constraint
//        print("!!!Recieved delta: \(delta), constraintDelta: \(deltaConstraint)")
//        let newHeight = headerView.frame.height - delta
//        print("!!! New height: \(newHeight)")
//        headerView.snp.updateConstraints { (m) in
//            m.top.left.right.equalToSuperview()
//            m.height.equalTo(newHeight)
//        }
//    }
    @objc func buttonAction(sender: UIButton!) {
      print("!!! Button tapped")
    }
    
    func setupUI() {
        view.backgroundColor = .white
//        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
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
            m.centerX.equalToSuperview()
            m.bottom.equalToSuperview().offset(-16)
        }
        
        pagingViewController.view.snp.makeConstraints { (m) in
            m.top.equalTo(headerView.snp.bottom)
            m.left.right.bottom.equalToSuperview()
        }

        
    }
    
    func populateBottomView() {
        
        let tabContentVC = ContentViewController()
        tabContentVC.innerTableViewScrollDelegate = self
        tabContentVC.numberOfCells = 30 // (subTabCount + 1) * 10

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
        return 5
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let tableViewVC = TableViewController()
        tableViewVC.innerTableViewScrollDelegate = self
        return tableViewVC
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: "View \(index+1)")
    }
    
    
}
//MARK:- Sticky Header Effect
extension ViewController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        let headerViewCurrentHeight = headerView.frame.height
//        print("!!!currentHeaderHeight: \(headerViewCurrentHeight)")
        return headerViewCurrentHeight
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        let newHeight = currentHeaderHeight - scrollDistance
        if (newHeight >= topViewFinalHeight && newHeight <= topViewInitialHeight) {
            headerView.snp.updateConstraints { (m) in
                print("!!! Constraints updating")
                m.top.left.right.equalToSuperview()
                m.height.equalTo(newHeight)
            }
        }
        
//        headerViewHeightConstraint -= scrollDistance
        print("!!!tableView Scrolldistance: ", scrollDistance, "New Height: ", newHeight)
        
        
        /* Don't restrict the downward scroll.
 
        if headerViewHeightConstraint.constant > topViewInitialHeight {
            headerViewHeightConstraint.constant = topViewInitialHeight
        }
         
        */
        
//        if headerViewHeightConstraint < topViewFinalHeight {
//
//            headerViewHeightConstraint = topViewFinalHeight
//        }
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = headerView.frame.height

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
            m.top.left.right.equalToSuperview()
            m.height.equalTo(topViewInitialHeight)
        }
        
//        headerViewHeightConstraint = topViewInitialHeight

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
            m.top.left.right.equalToSuperview()
            m.height.equalTo(topViewFinalHeight)
        }
        
//        headerViewHeightConstraint = topViewFinalHeight

        UIView.animate(withDuration: TimeInterval(time), animations: {

            self.view.layoutIfNeeded()
        })
    }

}
