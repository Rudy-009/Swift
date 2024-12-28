//
//  CollectionViewCell.swift
//  Concurrency_Test
//
//  Created by 이승준 on 12/28/24.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponents()
    }
    
    func configuration(image: UIImage) {
        imageView.image = image
    }
    
    private func addComponents() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
