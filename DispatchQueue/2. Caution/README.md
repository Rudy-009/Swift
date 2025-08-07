# DispatchQueue 사용시 주의할 점

# 1. DispatchQueue.main.sync

DispatchQueue.main.sync 는 금기입니다. 데드락이 발생하기 때문인데요. 제가 생각하는 데드락이 발생하는 과정을 알아보겠습니다.

![](Deadlock.png)

1. 메인 쓰레드에서 메인 큐로 동기적으로 작업을 보낸다.
2. 메인 쓰레드는 작업의 종료를 기다린다.
3. 메인 큐는 메인 쓰레드에 작업을 보낸다. **하지만 메인 쓰레드는 작업의 종료를 기다리는 중이므로 작업을 받을 수 없는 상황**

# 2. sync : 현재 큐에서 현재 큐로 작업(block)을 동기적으로 보내면 데드락이 발생할 수 있기 때문에 절대 사용해서는 안된다.

제목과 같이 [sync 공식문서](https://developer.apple.com/documentation/dispatch/dispatchqueue/sync(execute:)-3segw)에서 다음과 같이 경고하고 있습니다.

> Calling this function and targeting the current queue results in deadlock.

아래 예시는 시리얼 큐에서 다시 같은 시리얼 큐로 동기(sync) 작업을 보내는 코드입니다.

```swift
let serialQueue = DispatchQueue(label: "com.example.serial")

serialQueue.async { // block1
    print("block1 started")
    serialQueue.sync { // block2
        print("block2")
    }
    print("block1 finished")
}
```

**block1**이 Thread2에서 실행했다고 가정해봅시다. **DispatchQueue.global().sync**을 실행하면 block2를 시리얼 큐로 보내고 Thread2는 waiting 상태로 바뀝니다. 시리얼 큐에서 대기상태인 Thread2로 block2를 보낸다면 이로인해 **데드락**이 발생하게 됩니다.

## 글로벌 큐에서도?
[sync 공식문서](https://developer.apple.com/documentation/dispatch/dispatchqueue/sync(execute:)-3segw)에서 가능하다면 언제나 성능 향상을 위해서 현재 쓰레드로 block을 다시 보낸다고 합니다. 글로벌 큐에서도 상황이 맞다면 GCD가 대기상태인 Thread2로 보낼 수 있고 이로인해 **데드락**이 발생하게 됩니다. 하지만, 지금은 클로벌 큐를 통해 의도적으로 일으키려고 해도 잘 안되네요... 업그레이드했나...?

# 3. 강한 참조 주의 **[weak self]**

```swift
class ViewController: UIViewController {
    DispatchQueue.global().async { [weak self] in
        self?. ...
    }
}
```

- 비동기적으로 실행하면 백그라운드 쓰레드(메인 쓰레드 이외의 쓰레드)에서 클로저는 현재 ViewController를 참조하게 된다.
- 만약, ViewController가 dismiss (메모리에서 해제)된다면 메인 쓰레드에서는 해제되었지만, 참조 수가 남아서 메모리에서 해제되지 않습니다.

따라서 **[weak self]**를 통해 백그라운드 쓰레드가 참조 수를 올리지 못하게 하여 메모리 누수를 방지합니다.

# 4. UI 작업은 반드시 메인 쓰레드에서

```swift
DispatchQueue.main.async {
    // UI 작업
}
```

비동기 처리가 완료 되고 이를 UI에 반영하고 싶다면, 반드시 메인 쓰레드에서 실행될 수 있게 해주어야 합니다.

참고 자료

[앨런 iOS 앨런 iOS Concurrency(동시성)](https://www.inflearn.com/course/ios-concurrency-gcd-operation/dashboard)

[sync 공식문서](https://developer.apple.com/documentation/dispatch/dispatchqueue/sync(execute:)-3segw)