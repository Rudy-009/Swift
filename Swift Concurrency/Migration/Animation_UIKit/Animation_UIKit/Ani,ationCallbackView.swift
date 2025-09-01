//
//  Ani,ationCallbackView.swift
//  Animation_UIKit
//
//  Created by 이승준 on 9/1/25.
//

import UIKit

// MARK: - AnimationCallbackView
final class AnimationCallbackView: UIView {

    // Public UI components (VC에서 접근)
    public let mainTitleLabel = UILabel().then {
        $0.text = "같이 성장해나갈\n강아지를 선택해주세요"
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    public let dimView = UIView().then {
        $0.backgroundColor = .gray
        $0.alpha = 0
        $0.isUserInteractionEnabled = false
    }

    public let characterNameLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1)
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .center
        $0.isHidden = true
    }

    public let subTitleLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.557, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textAlignment = .center
        $0.isHidden = true
    }

    public let buttonsStackFrame = UIView()
    public let cardButton01 = CardButtonView()
    public let cardButton02 = CardButtonView()
    public let cardButton03 = CardButtonView()
    public let cardButton04 = CardButtonView()

    public let startButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.235, green: 0.235, blue: 0.235, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.backgroundColor = .systemYellow
        $0.layer.cornerRadius = 10
        $0.isHidden = true
    }

    public let brightView = UIView().then {
        $0.backgroundColor = .white
        $0.alpha = 0
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addAllSubviews()
        activateConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Layout
    private func addAllSubviews() {
        [dimView, mainTitleLabel, buttonsStackFrame,
         cardButton01, cardButton02, cardButton03, cardButton04,
         characterNameLabel, subTitleLabel, startButton, brightView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            // Dim view
            dimView.topAnchor.constraint(equalTo: topAnchor),
            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Main title
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            mainTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            mainTitleLabel.bottomAnchor.constraint(equalTo: buttonsStackFrame.topAnchor, constant: -40),

            // Buttons stack frame
            buttonsStackFrame.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            buttonsStackFrame.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55),
            buttonsStackFrame.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackFrame.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),

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
            characterNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            characterNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Subtitle label
            subTitleLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Start button
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34),
            startButton.heightAnchor.constraint(equalToConstant: 60),

            // Bright view
            brightView.topAnchor.constraint(equalTo: topAnchor),
            brightView.leadingAnchor.constraint(equalTo: leadingAnchor),
            brightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            brightView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Utilities
    public func reset() {
        [cardButton01, cardButton02, cardButton03, cardButton04].forEach { button in
            button.transform = .identity
            button.alpha = 1.0
            button.isEnabled = true
        }
        dimView.alpha = 0
        dimView.backgroundColor = .gray
        characterNameLabel.isHidden = true
        subTitleLabel.isHidden = true
        startButton.isHidden = true
        brightView.isHidden = true
        brightView.alpha = 0
    }
}
