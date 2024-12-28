//
//  View.swift
//  Concurrency_Test
//
//  Created by 이승준 on 12/28/24.
//

import UIKit

class MainView: UIView {
    
    let collection: UICollectionView = {
        
        let screenWidth = UIScreen.main.bounds.width
        let flow = UICollectionViewFlowLayout()
        let cellWidth = screenWidth
        
        flow.estimatedItemSize = .init(width: cellWidth-5 , height: cellWidth-5)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        collection.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collection.showsVerticalScrollIndicator = false // Scrollbar
        
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponents()
    }
    
    private func addComponents() {
        self.addSubview(collection)
        
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
