//
//  View.swift
//  Concurrency_Test
//
//  Created by 이승준 on 12/28/24.
//

import UIKit

class MainView: UIView {
    let collection: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        return collection
    }()
    
    
    
}
