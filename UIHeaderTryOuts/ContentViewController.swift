//
//  ContentViewController.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-02-22.
//

import UIKit

//enum DragDirection {
//    case Up
//    case Down
//}
//
//protocol InnerTableViewScrollDelegate: class {
//    var currentHeaderHeight: CGFloat { get }
//    
//    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
//    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection)
//}

class ContentViewController: UIViewController {
    var tableView: UITableView!
    
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    var numberOfCells: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! TableViewCell
        cell.titleLabel.text = "Cell nr \(indexPath.row + 1)"
        return cell
    }
}

extension ContentViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            if delta < 0,
               // topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
               scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        print("ScrollViewDidEndDecelrating")
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
}
