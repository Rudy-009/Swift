# 콜백 지옥

![asyncAnimation.gif](asyncAnimation.gif)

위 애니메이션을 구현하는 과정에서 콜백 지옥을 경험했다. 당시에는 짧은 시간 내에 결과를 도출해야 했기에 되는대로 구현할 수 밖에 없었다.

```swift
UIView.animate(withDuration: 0.3) {
        // 선택되지 않은 카드들은 흐리게 처리
} completion: { _ in // dim 효과 완료 후 카드 확대 애니메이션
    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, // 스프링 효과를 더 부드럽게
                    initialSpringVelocity: 0.3) { // 초기 속도를 낮춤
        // ...
    } completion: { _ in
        UIView.transition(with: sender, duration: 0.7, options: .transitionFlipFromRight, animations: nil) { _ in
            UIView.transition(with: sender, duration: 0.7, options: .transitionFlipFromRight, animations: nil) { _ in
                UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { _ in
                    // 훨씬 더 많음
                    // ...
                } // Third 0.5
            } // Second: 0.7
        } // First: 0.7
    }
}
```