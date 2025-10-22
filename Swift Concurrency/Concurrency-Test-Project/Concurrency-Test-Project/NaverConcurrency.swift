//
//  NaverConcurrency.swift
//  Concurrency-Test-Project
//
//  Created by 이승준 on 10/22/25.
//

// https://engineering.linecorp.com/ko/blog/about-swift-concurrency

import UIKit

final class NaverConcurrency: UIViewController {
    
    var count: Int = 0
    var failureCount: Int = 0
    
    let urls: [URL] = Array<URL>(repeating: URL(string: "https://picsum.photos/200")!, count: 200)
    let serial = DispatchQueue(label: "com.DownloadImageManager.serial")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupCenterImageView()
        downloadImages()
    }
        
    private let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let countLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

extension NaverConcurrency {
    
    func downloadImages() {
        for (index, url) in urls.enumerated() {
            downloadImageWithURL(url: url, session: URLSession.shared) { image, error in
                DispatchQueue.main.async {
                    self.serial.sync {
                        self.count += 1
                    }
                    guard let image = image else {
                        self.failureCount += 1
                        return
                    }
                    self.updateUI(image: image, count: self.count)
                }
                self.serial.sync {
                    print("\(index)/\(self.urls.count) done : \(self.count)")
                }
            }
        }
    }
    
    func downloadImageWithURL(url: URL,
                              session: URLSession,
                              completion: @escaping (UIImage?, Error?) -> Void) {
        session.dataTask(with: url) { data, response, error in
            guard let imageData = data else {
                completion(nil, nil)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse,
                  urlResponse.statusCode == 200 else {
                completion(nil, nil)
                return
            }
            let image = UIImage(data: imageData)
            completion(image, nil)
        }.resume()
    }
}

extension NaverConcurrency {
    
    private func updateUI(image: UIImage, count: Int) {
        centerImageView.image = image
        countLabel.text = "\(count)"
    }
    
    private func setupCenterImageView() {
        view.addSubview(countLabel)
        view.addSubview(centerImageView)
        
        // Auto Layout 제약 조건 설정
        NSLayoutConstraint.activate([
            centerImageView.widthAnchor.constraint(equalToConstant: 300),
            centerImageView.heightAnchor.constraint(equalToConstant: 300),
            centerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countLabel.bottomAnchor.constraint(equalTo: centerImageView.topAnchor, constant: -20)
        ])
    }

}
