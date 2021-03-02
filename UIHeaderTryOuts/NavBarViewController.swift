//
//  NavBarViewController.swift
//  UIHeaderTryOuts
//
//  Created by Peter Szücs on 2021-03-01.
//

import UIKit

class NavBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Only Nav"
        view.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

}
