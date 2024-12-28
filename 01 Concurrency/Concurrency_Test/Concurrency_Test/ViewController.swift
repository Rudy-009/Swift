//
//  ViewController.swift
//  Concurrency_Test
//
//  Created by 이승준 on 12/28/24.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
    
    let unsplashAccessKey = Bundle.main.infoDictionary?["UnsplashAccessKey"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

}

