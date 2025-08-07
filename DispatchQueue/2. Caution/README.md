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

**block1**이 Thread2에서 실행했다고 가정해봅시다. **DispatchQueue.global().sync**을 실행하면 block2를 시리얼 큐로 보내고 Thread2는 waiting 상태로 바뀝니다. [sync 공식문서](https://developer.apple.com/documentation/dispatch/dispatchqueue/sync(execute:)-3segw)에서 가능하다면 언제나 성능 향상을 위해서 현재 쓰레드로 block을 다시 보낸다고 합니다. 즉, 상황이 맞다면 GCD가 대기상태인 Thread2로 보낼 수 있고 이로인해 **데드락**이 발생하게 됩니다.