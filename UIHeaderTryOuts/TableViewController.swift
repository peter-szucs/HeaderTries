//
//  TableViewController.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-02-22.
//

import UIKit
import SnapKit

enum DragDirection {
    case Up
    case Down
}

protocol InnerTableViewScrollDelegate: class {
    var currentHeaderHeight: CGFloat { get }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection)
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Scroll Delegate
    
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    //MARK:- Stored Properties for Scroll Delegate
    
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    private var dummyData: [String] = ["Test", "Hej", "Japp", "Kanske", "Ok", "Hmmm", "Titlar?", "Svårt", "Att", "Komma", "På", "Så", "Blir", "Bara", "Detta"]
    private var cellID = "CellID"
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.register(TableViewCell.self, forCellReuseIdentifier: cellID)
        return tv
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        self.title = "TableView"
        
        tableView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dummyData.count
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: Cell \(indexPath.row)")
        let detailVC = DetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableViewCell
//        cell.setCell(title: dummyData[indexPath.row])
        cell.setCell(title: "Cell Nr \(indexPath.row + 1)")
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
//        let deltaDataDict: [String : CGFloat] = ["deltaNumber" : delta]
//
//        NotificationCenter.default.post(name: Notification.Name("delta"), object: nil, userInfo: ["deltaNumber": delta])
//        print("!!! delta: \(delta), oldContentOffset: \(oldContentOffset.y)")
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        print("!!! delta: \(delta), oldContentOffset: \(oldContentOffset.y) topViewCurrentHeightConst: ", topViewCurrentHeightConst)
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
//            print("!!! topViewUnwrapped Height: ", topViewUnwrappedHeight)
//            print("!!! scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
//                print("!!! delta > 0 triggered")
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
//                print("!!!Delta: ", delta)
                scrollView.contentOffset.y -= delta
            }
            
            if delta < 0,
               topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
               scrollView.contentOffset.y < 0 {
//                print("!!! delta < 0 triggered")
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
//        print("!!!!ScrollViewDidEndDecelerating")
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
//        print("!!!ScrollViewDidEndDraging")
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
}
