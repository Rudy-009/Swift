//
//  CallbackHell.swift
//  Animation_UIKit
//
//  Created by 이승준 on 9/1/25.
//
import UIKit

import UIKit

final class AnimationCallbackViewController: UIViewController {
    
    private var rootView: AnimationCallbackView { view as! AnimationCallbackView }

    // MARK: - Lifecycle
    override func loadView() {
        view = AnimationCallbackView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }

    private func setupButtons() {
        rootView.cardButton01.setId(id: 1)
        rootView.cardButton02.setId(id: 2)
        rootView.cardButton03.setId(id: 3)
        rootView.cardButton04.setId(id: 4)

        rootView.cardButton01.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        rootView.cardButton02.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        rootView.cardButton03.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        rootView.cardButton04.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)

        rootView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    @objc private func cardButtonTapped(_ sender: CardButtonView) {
        showDimAndActiveAnimation(sender)
    }

    @objc private func startButtonTapped() {
        rootView.reset()
    }
    
    public func showDimAndActiveAnimation(_ sender: CardButtonView) {
        // 화면 크기 계산
        let screenWidth = rootView.bounds.width
        let screenHeight = rootView.bounds.height
        // 목표 크기
        let targetWidth = (Double(screenWidth) * 1.8) / 3.0
        let targetHeight = Double(targetWidth) * 1.8
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

        rootView.bringSubviewToFront(rootView.dimView)
        rootView.bringSubviewToFront(sender)

        UIView.animate(withDuration: 0.3) { // 선택되지 않은 카드들은 흐리게 처리
            self.rootView.dimView.alpha = 0.6
            [self.rootView.cardButton01, self.rootView.cardButton02, self.rootView.cardButton03, self.rootView.cardButton04].forEach { button in
                if button != sender {
                    button.alpha = 0.5
                }
            }
        } completion: { _ in // dim 효과 완료 후 카드 확대 애니메이션
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, // 스프링 효과를 더 부드럽게
                           initialSpringVelocity: 0.3) { // 초기 속도를 낮춤
                sender.transform = CGAffineTransform.identity
                    .translatedBy(x: translateX, y: translateY)
                    .scaledBy(x: scaleX, y: scaleY)
            } completion: { _ in
                UIView.transition(with: sender, duration: 0.7, options: .transitionFlipFromRight, animations: nil) { _ in
                    UIView.transition(with: sender, duration: 0.7, options: .transitionFlipFromRight, animations: nil) { _ in
                        UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { _ in
                            UIView.transition(with: sender, duration: 0.4, options: .transitionFlipFromRight, animations: nil) { _ in
                                UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromRight, animations: nil) { _ in
                                    self.sparkStart()
                                    UIView.transition(with: sender, duration: 0.2, options: .transitionFlipFromRight, animations: nil) { _ in
                                        UIView.transition(with: sender, duration: 0.2, options: .transitionFlipFromRight, animations: nil) { _ in
                                            UIView.transition(with: sender, duration: 0.2, options: .transitionFlipFromRight, animations: nil) { _ in
                                                UIView.transition(with: sender, duration: 0.1, options: .transitionFlipFromRight, animations: nil) { _ in
                                                    UIView.transition(with: sender, duration: 0.1, options: .transitionFlipFromRight, animations: nil) { _ in
                                                        UIView.transition(with: sender, duration: 0.1, options: .transitionFlipFromRight, animations: nil) { _ in
                                                            UIView.transition(with: sender, duration: 0.1, options: .transitionFlipFromRight, animations: nil) { _ in
                                                                // White Effect
                                                                UIView.animate(withDuration: 0.1) {
                                                                    self.setCardImage(sender: sender)
                                                                    self.rootView.dimView.backgroundColor = .white
                                                                    self.rootView.dimView.alpha = 1
                                                                    sender.isEnabled = false

                                                                    self.rootView.characterNameLabel.isHidden = false
                                                                    self.rootView.subTitleLabel.isHidden = false
                                                                    self.rootView.startButton.isHidden = false
                                                                } completion: { _ in
                                                                    self.sparkEnd()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } // Forth 0.4
                        } // Third 0.5
                    } // Second: 0.7
                } // First: 0.7
            }
        }
    }

    // MARK: - Helpers
    private func sparkStart() {
        UIView.animate(withDuration: 0.5) { // bright
            self.rootView.bringSubviewToFront(self.rootView.brightView)
            self.rootView.brightView.isHidden = false
            self.rootView.brightView.alpha = 1
        }
    }

    private func sparkEnd() {
        UIView.animate(withDuration: 0.5) {
            self.rootView.brightView.alpha = 0
            self.rootView.bringSubviewToFront(self.rootView.characterNameLabel)
            self.rootView.bringSubviewToFront(self.rootView.subTitleLabel)
            self.rootView.bringSubviewToFront(self.rootView.startButton)
        } completion: { _ in
            self.rootView.sendSubviewToBack(self.rootView.brightView)
        }
    }

    private func setCardImage(sender: CardButtonView) {
        guard let id = sender.getID() else { return }
        switch id {
        case 1:
            rootView.characterNameLabel.text = "Card 1"
            rootView.subTitleLabel.text = "pink"
            sender.cardImage.backgroundColor = .systemPink
        case 2:
            rootView.characterNameLabel.text = "Card 2"
            rootView.subTitleLabel.text = "orange"
            sender.cardImage.backgroundColor = .systemOrange
        case 3:
            rootView.characterNameLabel.text = "Card 3"
            rootView.subTitleLabel.text = "purple"
            sender.cardImage.backgroundColor = .systemPurple
        case 4:
            rootView.characterNameLabel.text = "Card 4"
            rootView.subTitleLabel.text = "green"
            sender.cardImage.backgroundColor = .systemGreen
        default:
            rootView.characterNameLabel.text = "Undefined"
            rootView.subTitleLabel.text = "gray"
            sender.cardImage.backgroundColor = .gray
        }
    }
}
