//
//  callbackHell.swift
//  Animation_UIKit
//
//  Created by 이승준 on 8/24/25.
//

import UIKit
import SnapKit
import Then

final class ConcurrencyAnimationViewController: UIViewController {

    // 커스텀 루트 뷰로 다운캐스트
    private var rootView: ConcurrencyAnimationView { view as! ConcurrencyAnimationView }

    // MARK: - Lifecycle
    override func loadView() {
        // ViewController의 루트 뷰를 커스텀 뷰로 교체
        view = ConcurrencyAnimationView()
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

        rootView.retryButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }

    @objc private func cardButtonTapped(_ sender: CardButtonView) {
        Task { await showDimAndActiveAnimation(sender) }
    }

    @objc private func resetButtonTapped() {
        rootView.reset()
    }

    // MARK: - Concurrency-friendly animation wrappers
    @MainActor
    private func dimAnimation(without sender: UIView) async {
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 0.3, animations: {
                self.rootView.dimView.alpha = 0.6
                [self.rootView.cardButton01, self.rootView.cardButton02,
                 self.rootView.cardButton03, self.rootView.cardButton04].forEach { button in
                    if button != sender { button.alpha = 0.5 }
                }
            }, completion: { _ in
                continuation.resume()
            })
        }
    }

    @MainActor
    private func enlargeAnimation(_ sender: UIView) async {
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

        await withCheckedContinuation { continuation in
            UIView.animate(
                withDuration: 1.0,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.3,
                animations: {
                    sender.transform = CGAffineTransform.identity
                        .translatedBy(x: translateX, y: translateY)
                        .scaledBy(x: scaleX, y: scaleY)
                },
                completion: { _ in continuation.resume() }
            )
        }
    }

    @MainActor
    private func rotateAnimation(_ sender: UIView, duration: TimeInterval) async {
        await withCheckedContinuation { continuation in
            UIView.transition(with: sender, duration: duration, options: .transitionFlipFromRight, animations: nil) { _ in
                continuation.resume()
            }
        }
    }

    // MARK: - High-level animation flow (practice target)
    @MainActor
    public func showDimAndActiveAnimation(_ sender: CardButtonView) async {
        rootView.bringSubviewToFront(rootView.dimView)
        rootView.bringSubviewToFront(sender)

        // 1단계: 다른 카드 dim 처리
        await dimAnimation(without: sender)

        // 2단계: 확대(이동+스케일)
        await enlargeAnimation(sender)

        // 3단계: 여러 단계 플립 회전
        for duration in [0.7, 0.7, 0.5, 0.4, 0.3] {
            await rotateAnimation(sender, duration: duration)
        }

        sparkStart()
        for duration in [0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1] {
            await rotateAnimation(sender, duration: duration)
        }

        // 최종 화이트 효과 + UI 노출
        UIView.animate(withDuration: 0.1) {
            self.setCardImage(sender: sender)
            self.rootView.dimView.backgroundColor = .white
            self.rootView.dimView.alpha = 1
            sender.isEnabled = false

            self.rootView.characterNameLabel.isHidden = false
            self.rootView.subTitleLabel.isHidden = false
            self.rootView.retryButton.isHidden = false
        } completion: { _ in
            self.sparkEnd()
        }
    }

    // MARK: - Helpers
    @MainActor
    private func sparkStart() {
        UIView.animate(withDuration: 0.5) {
            self.rootView.bringSubviewToFront(self.rootView.brightView)
            self.rootView.brightView.isHidden = false
            self.rootView.brightView.alpha = 1
        }
    }

    @MainActor
    private func sparkEnd() {
        UIView.animate(withDuration: 0.5) {
            self.rootView.brightView.alpha = 0
            self.rootView.bringSubviewToFront(self.rootView.characterNameLabel)
            self.rootView.bringSubviewToFront(self.rootView.subTitleLabel)
            self.rootView.bringSubviewToFront(self.rootView.retryButton)
        } completion: { _ in
            self.rootView.sendSubviewToBack(self.rootView.brightView)
        }
    }

    @MainActor
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
