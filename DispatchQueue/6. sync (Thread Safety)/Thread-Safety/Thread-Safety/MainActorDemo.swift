//
//  MainActorDemo.swift
//  Thread-Safety
//
//  Created by 이승준 on 8/22/25.
//

import UIKit

class MainActorDemo: UIViewController {
    
    lazy var classLabel = self.label(classInstance.title)
    lazy var classAsyncLabel = self.label(classInstanceAsync.title)
    lazy var mainActorLabel = self.label(mainActorInstance.title)
    
    var count: Int = 0
    
    let classInstance = ClassDemonstration()
    let classInstanceAsync = ClassAsyncDemonstration()
    let mainActorInstance = MainActorDemonstration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        uiSetup()
    }
    
    func uiSetup() {
        view.addSubview(classLabel)
        classLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        
        view.addSubview(classAsyncLabel)
        classAsyncLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classAsyncLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classAsyncLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        view.addSubview(mainActorLabel)
        mainActorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainActorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainActorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160)
        ])
        
        let actionButton = self.button("Button")
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: mainActorLabel.bottomAnchor, constant: 100)
        ])
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    func button(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        return button
    }

    @objc func buttonTapped() {
        count += 1
        print("button pressed \(count)")
        
//        DispatchQueue.global().async {
//            self.classInstance.changeTitle(to: "new class \(self.count)")
//            self.classLabel.text = self.classInstance.title
//        }
        
        Task {
            await classInstanceAsync.changeTitle(to: "new async class \(count)")
            self.classAsyncLabel.text = self.classInstanceAsync.title
            classInstanceAsync.changeTitleWithoutMainActor(to: "new non mainActor async mehtod")
        }
        
//        Task {
//            await mainActorInstance.changeTitle(to: "new main actor \(count)")
//            self.mainActorLabel.text = self.mainActorInstance.title
//        }
    }
    
}

class ClassDemonstration {
    var title = "class"
    
    func changeTitle(to content: String) {
        title = content
        print("is Main Thread: \(Thread.isMainThread)")
    }
}

class ClassAsyncDemonstration {
    var title = "class async"
    
    @MainActor
    func changeTitle(to content: String) async {
        title = content
        print("is Main Thread: \(Thread.isMainThread)")
    }
    
    func changeTitleWithoutMainActor(to content: String) {
        title = content
        print("is Main Thread: \(Thread.isMainThread)")
    }
}

@MainActor
class MainActorDemonstration {
    var title = "main actor"
    
    func changeTitle(to content: String) async {
        title = content
        print("is Main Thread: \(Thread.isMainThread)")
    }
}

import SwiftUI

#Preview {
    MainActorDemo()
}
