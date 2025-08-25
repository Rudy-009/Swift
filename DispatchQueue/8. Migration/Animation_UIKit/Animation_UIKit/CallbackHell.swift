//
//  callbackHell.swift
//  Animation_UIKit
//
//  Created by 이승준 on 8/24/25.
//

import UIKit
import SnapKit
import Then

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

// MARK: - Main Practice View
class AnimationPracticeViewController: UIViewController {
    
    // UI Components
    private lazy var mainTitleLabel = UILabel().then {
        $0.text = "카드를 선택해주세요"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let dimView = UIView().then {
        $0.backgroundColor = .gray
        $0.alpha = 0
    }
    
    private lazy var characterNameLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private lazy var buttonsStackFrame = UIView()
    
    public lazy var cardButton01 = CardButtonView()
    public lazy var cardButton02 = CardButtonView()
    public lazy var cardButton03 = CardButtonView()
    public lazy var cardButton04 = CardButtonView()
    
    public lazy var retryButton = UIButton().then {
        $0.setTitle("다시 뽑기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.backgroundColor = .systemYellow
        $0.layer.cornerRadius = 10
        $0.isHidden = true
    }
    
    public lazy var brightView = UIView().then {
        $0.backgroundColor = .white
        $0.alpha = 0
        $0.isHidden = true
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add all subviews
        [dimView, mainTitleLabel, buttonsStackFrame,
         cardButton01, cardButton02, cardButton03, cardButton04,
         characterNameLabel, subTitleLabel, retryButton, brightView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Dim view
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Main title
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            mainTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            mainTitleLabel.bottomAnchor.constraint(equalTo: buttonsStackFrame.topAnchor, constant: -40),
            
            // Buttons stack frame
            buttonsStackFrame.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            buttonsStackFrame.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            buttonsStackFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackFrame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            // Card buttons
            cardButton01.leadingAnchor.constraint(equalTo: buttonsStackFrame.leadingAnchor),
            cardButton01.topAnchor.constraint(equalTo: buttonsStackFrame.topAnchor),
            cardButton01.widthAnchor.constraint(equalTo: buttonsStackFrame.widthAnchor, multiplier: 0.428),
            cardButton01.heightAnchor.constraint(equalTo: buttonsStackFrame.heightAnchor, multiplier: 0.444),
            
            cardButton02.trailingAnchor.constraint(equalTo: buttonsStackFrame.trailingAnchor),
            cardButton02.topAnchor.constraint(equalTo: buttonsStackFrame.topAnchor),
            cardButton02.widthAnchor.constraint(equalTo: buttonsStackFrame.widthAnchor, multiplier: 0.428),
            cardButton02.heightAnchor.constraint(equalTo: buttonsStackFrame.heightAnchor, multiplier: 0.444),
            
            cardButton03.leadingAnchor.constraint(equalTo: buttonsStackFrame.leadingAnchor),
            cardButton03.bottomAnchor.constraint(equalTo: buttonsStackFrame.bottomAnchor),
            cardButton03.widthAnchor.constraint(equalTo: buttonsStackFrame.widthAnchor, multiplier: 0.428),
            cardButton03.heightAnchor.constraint(equalTo: buttonsStackFrame.heightAnchor, multiplier: 0.444),
            
            cardButton04.trailingAnchor.constraint(equalTo: buttonsStackFrame.trailingAnchor),
            cardButton04.bottomAnchor.constraint(equalTo: buttonsStackFrame.bottomAnchor),
            cardButton04.widthAnchor.constraint(equalTo: buttonsStackFrame.widthAnchor, multiplier: 0.428),
            cardButton04.heightAnchor.constraint(equalTo: buttonsStackFrame.heightAnchor, multiplier: 0.444),
            
            // Character name label
            characterNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            characterNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Subtitle label
            subTitleLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Start button
            retryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            retryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            retryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            retryButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Bright view
            brightView.topAnchor.constraint(equalTo: view.topAnchor),
            brightView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            brightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            brightView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        cardButton01.setId(id: 1)
        cardButton02.setId(id: 2)
        cardButton03.setId(id: 3)
        cardButton04.setId(id: 4)
        
        cardButton01.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        cardButton02.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        cardButton03.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        cardButton04.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        
        retryButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cardButtonTapped(_ sender: CardButtonView) {
        Task {
            await showDimAndActiveAnimation(sender)
        }
    }
    
    @objc private func resetButtonTapped() {
        resetView()
    }
    
    private func resetView() {
        [cardButton01, cardButton02, cardButton03, cardButton04].forEach { button in
            button.transform = .identity
            button.alpha = 1.0
            button.isEnabled = true
        }
        
        dimView.alpha = 0
        dimView.backgroundColor = .gray
        characterNameLabel.isHidden = true
        subTitleLabel.isHidden = true
        retryButton.isHidden = true
        brightView.isHidden = true
        brightView.alpha = 0
    }
    
    func dimAnimation(without sender: UIView) async {
        return await withCheckedContinuation { continuation in
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.dimView.alpha = 0.6
                    [self.cardButton01, self.cardButton02, self.cardButton03, self.cardButton04].forEach { button in
                        if button != sender{
                            button.alpha = 0.5
                        }
                    }
                },
                completion: { _ in
                    continuation.resume()
                }
            )
        }
    }
    
    func enlargeAnimation(_ sender: UIView) async {
        // 화면 크기 계산
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
        
        // 목표 크기
        let targetWidth = (Double(screenWidth) * 1.8)/3.0
        let targetHeight = (Double)(targetWidth) * 1.8
        
        // 현재 카드의 크기
        let currentWidth = sender.bounds.width
        let currentHeight = sender.bounds.height
        
        // 스케일 계산
        let scaleX = targetWidth / currentWidth
        let scaleY = targetHeight / currentHeight
        
        // 화면 중앙 위치 계산
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // 선택된 카드 중앙으로 이동 및 크기 조정
        let translateX = centerX - sender.center.x
        let translateY = centerY - sender.center.y
        return await withCheckedContinuation { continuation in
            UIView.animate(
                withDuration: 1.0,
                delay: 0,
                usingSpringWithDamping: 0.7, // 스프링 효과를 더 부드럽게
                initialSpringVelocity: 0.3,
                animations: {
                    sender.transform = CGAffineTransform.identity
                        .translatedBy(x: translateX, y: translateY)
                        .scaledBy(x: scaleX, y: scaleY)
                }
                , completion : {_ in 
                    continuation.resume()
                }
            )
        }
    }
    
    func rotateAnimation(_ sender: UIView, duration: TimeInterval) async {
        return await withCheckedContinuation { continuation in
            UIView.transition( with: sender, duration: duration, options: .transitionFlipFromRight , animations: nil ) { _ in
                continuation.resume()
            }
        }
    }
    
    // MARK: - Animation Methods (여기가 연습 대상 코드!)
    @MainActor
    public func showDimAndActiveAnimation(_ sender: CardButtonView) async {
        
        self.view.bringSubviewToFront(dimView)
        self.view.bringSubviewToFront(sender)
        
        // 1단계 : 선택된 카드 이외의 self, 나머지 카드들에게 dimAnimation 적용
        await dimAnimation(without: sender)
        // 2단계 : dim 효과 이후, 카드 확대 애니메이션
        await enlargeAnimation(sender)
        // 3단계 : 카드 회전
        for duration in [0.7, 0.7, 0.5, 0.4, 0.3] {
            await rotateAnimation(sender, duration: duration)
        }
        self.sparkStart()
        for duration in [0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1] {
            await rotateAnimation(sender, duration: duration)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.setCardImage(sender: sender)
            self.dimView.backgroundColor = .white
            self.dimView.alpha = 1
            sender.isEnabled = false

            self.characterNameLabel.isHidden = false
            self.subTitleLabel.isHidden = false
            self.retryButton.isHidden = false
        } completion: { _ in
            self.sparkEnd()
        }
    }
    
    private func sparkStart() {
        UIView.animate(withDuration: 0.5) { // bright
            self.view.bringSubviewToFront(self.brightView)
            self.brightView.isHidden = false
            self.brightView.alpha = 1
        }
    }
    
    private func sparkEnd() {
        UIView.animate(withDuration: 0.5) {
            self.brightView.alpha = 0
            self.view.bringSubviewToFront(self.characterNameLabel)
            self.view.bringSubviewToFront(self.subTitleLabel)
            self.view.bringSubviewToFront(self.retryButton)
        } completion: { _ in
            self.view.sendSubviewToBack(self.brightView)
        }
    }
    
    private func setCardImage(sender: CardButtonView) {
        guard let id = sender.getID() else { return }
        
        switch id {
        case 1:
            self.characterNameLabel.text = "Card 1"
            self.subTitleLabel.text = "pink"
            sender.cardImage.backgroundColor = .systemPink
        case 2:
            self.characterNameLabel.text = "Card 2"
            self.subTitleLabel.text = "orange"
            sender.cardImage.backgroundColor = .systemOrange
        case 3:
            self.characterNameLabel.text = "Card 3"
            self.subTitleLabel.text = "purple"
            sender.cardImage.backgroundColor = .systemPurple
        case 4:
            self.characterNameLabel.text = "Card 4"
            self.subTitleLabel.text = "green"
            sender.cardImage.backgroundColor = .systemGreen
        default:
            self.characterNameLabel.text = "Ubdefined"
            self.subTitleLabel.text = "gray"
            sender.cardImage.backgroundColor = .gray
        }
    }
}

