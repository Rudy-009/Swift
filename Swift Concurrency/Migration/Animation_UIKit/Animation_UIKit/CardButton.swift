//
//  CardButton.swift
//  Animation_UIKit
//
//  Created by 이승준 on 9/1/25.
//

import UIKit

// MARK: - PuppyCardButtonView
class CardButtonView: UIButton {
    
    public lazy var cardImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
    }
    
    private var id: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFrame()
        addComponents()
    }
    
    private func setFrame() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1).cgColor
    }
    
    private func addComponents() {
        self.addSubview(cardImage)
        self.backgroundColor = .white
        
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cardImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cardImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            cardImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            cardImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cardImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    public func setId(id: Int) {
        self.id = id
    }
    
    public func getID() -> Int? {
        return self.id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
