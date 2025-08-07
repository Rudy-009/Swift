# 머릿말
동시, 순서, 동기, 비동기, DispatchQeueu, GCD, QoS 등에 간단하게 하도 알고 계시면 이 글을 읽으시는걸 추천드려요. 하지만, 잘 모르시면 ![앞선 글](https://velog.io/@rudy009/DispatchQueue)을 미리 읽고 오시는 것을 추천합니다.

# DispatchQueue

Dispatch Queue를 단어 그대로 해석한다면 **'전송(하는) 큐'**는 의미입니다. 즉, 작업을 어떤 큐에 전송하라는 뜻이죠. 자주 사용하는 코드로 예시를 볼까요?

```swift
DispatchQueue.main().async {
	// 작업
}
```

- `main()` 은 큐의 종류 중 하나입니다. 메인 큐라고 부르죠
- `async` 는 비동기적으로 보내라는 의미입니다. 즉, 종료를 기다리지 말고 다음 작업을 하라는 이미입니다.

이 코드는 **'작업을 비동기 적으로 메인에 전송하는 큐'**는 의미가 되겠네요.

`DispatchQueue.main().async{}` 라는 코드는 DispatchQueue를 구체화해서 정확히 어떤 큐에 작업을 보내고 작업 종료의 대기 여부를 결정합니다.

이제 DispatchQueue를 사용하는 방법을 알게 되신겁니다.

앞으로 큐의 종류, 큐의 서비스 품질, (동기, 비동기)를 알아보며 각자 어떤 역할을 하는지 알아보겠습니다.

# DispatchQueue의 종류

## 메인 큐 (Main Queue)

- 공식문서
> The dispatch queue associated with the main thread of the current process.

현재 프로세스에서 메인 큐는 메인 쓰레드(1번 쓰레드)로 보내는 전송 큐입니다.

### 메인 쓰레드 (Main Thread)
그럼 메인 쓰레드란? iOS, MacOS 등에서 사용자와의 상호작용 혹은 UI를 그리는 작업을 합니다. 만약 조금이라도 딜레이가 보인다면 사용자는 앱이 고장났다고 생각할 수 있기 때문에 반드시 필요하지 않는다면 대부분 다른 쓰레드에서 작업을 실행시키는게 좋습니다.

익숙한 코드를 보며 어떤 의미였는지 천천히 살펴보겠습니다.

```swift
DispatchQueue.main.async {
	// Task1
}
// Task2
```

![](main.async{}.png)

1. 메인 큐에 비동기적으로 작업 Task1을 전송한다.
2. 메인 쓰레드는 Task1의 종료를 기다리지 않고 다음 작업(Task2)를 수행한다.
3. 메인 큐는 적재된 작업을 메인 쓰레드에 전송한다.
4. Task1의 코드가 실행된다.

코드로 실행하게 된다면 아래와 같을 것입니다.

```swift
import Foundation
print("Task0")
DispatchQueue.main.async {
    sleep(1) // 지연을 표현하기 위한 코드
    print("Task1")
    exit(0) // 프로그램 종료
}
print("Task2")
RunLoop.main.run() // 프로그램 종료 방지
```

```
Task0
Task2
Task1
```

잠깐, 우리가 짜는 코드는 대부분 순서대로 메인 쓰레드에서 돌아가는데 왜 굳이 또 메인으로 보내야 하는 걸까요? 만약 사실상 우리가 짜는 코드는 `main.sync(){}` 아닌가? 라고 생각하실 수 있습니다. 

## 왜 굳이 메인으로 보내는가?

```DispatchQueue.main.async``` 코드를 쓰는 상황을 다시 한 번 생각해 볼까요? 주로 네트워크 컴플리션 핸들러와 같은 비동기 작업이 끝난 결과를 UI에 반영하는 코드를 넣었을 겁니다. 이 코드는 비동기 작업이 완료 되고 이 결과를 UI에 반영하기 위한 것처럼 반드시 메인 쓰레드에서 작동해야 하는 작업을 의미합니다.

그럼 위 사진은? 저 코드가 메인에서 실행 되었기 때문에 저렇게 그렸을 뿐, 실제 여러분이 사용하셨던 코드는 아래 사진과 같았을 겁니다.

![](network.png)
1. 네트워크 작업 종료이후 `DispatchQueue.main.async{}` 실행
2. 비동기 메인 큐로 보냄
3. 메인 큐는 메인 쓰레드에 작업을 보냄
4. 메인 쓰레드에서 Task1 실행

## main.sync는 데드락을 발생시킨다!

공식문서를 보겠습니다.
> Attempting to synchronously execute a work item on the main queue results in deadlock.

만약, 동기적으로 메인 큐에 작업을 실행하게 된다면 데드락이 발생한다고 경고하고 있습니다.


```swift
DispatchQueue.main.sync {
    // 작업
}
```

![](Deadlock.png)
1. Task1을

main 쓰레드가 어떤 작업이 끝나기를 기다리는 것은 매우 위험합니다. 다른 중요한 작업들이 많기 때문이죠.

메인 큐는 UI를 그리는 작업을 하기 때문에 다른 작업이 지연되는 것을 지양합니다. UI 작업이 느려지면 사용자는 앱이 고장난것으로 간주할 수 있기 때문이죠, 그래서 작업이 오래 걸리는 경우 비동기 작업으로 빼는 것입니다.

## 글로벌 큐 (Global Queue)

공식문서
> Returns the global system queue with the specified quality-of-service class.

```swift
class func global(qos: DispatchQoS.QoSClass = .default) -> DispatchQueue
```

qos가 정해진 전송 큐를 반환하는 타입 메서드입니다.

또한, 글로벌 큐는 동시 큐입니다. 이 설정은 바꿀 수 없습니다.

왜일까요? 제 개인적인 생각으로 글로벌 큐는 QoS가 중요한 전송 큐입니다. 만약, 글로벌 큐가 순서큐라면 어떻게 될까요? QoS를 설정하는 것이 의미가 없어지겠죠.

## 프라이빗 큐 (Private Queue)

공식문서
> Creates a new dispatch queue to which you can submit blocks.

`let queue = DispatchQueue(label: "com.example.concurrentQueue")`

사용자가 원하는 전송 큐를 만들 수 있다.

```swift
init(
    label: String,
    qos: DispatchQoS = .unspecified,
    attributes: DispatchQueue.Attributes = [],
    autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit,
    target: DispatchQueue? = nil
)
```

qos : .unspecified (기본)
attributes : [] (기본, serial 큐를 의미합니다.) / 동시 큐를 원한다면 .concurrent로 설정하면 됩니다.

## 정리

```swift
DispatchQueue.{큐 종류 (main, global, private)}(qos: QoS).{async/sync} {
	// 작업
}
```

아래 테이블은 Queue의 종류별로 고정된 값을 정리했습니다.
|Queue 종류	| 특징 |	QoS 제약 |	큐 유형 제약 |
| --       | --- | --- | --- |
|main       |UI 스레드 전용  | .userInteractive 고정| 	Serial(순서) 고정 |
|global     |시스템 글로벌 큐 |	모든 QoS 사용 가능 |	Concurrent(동시) 고정 |
|private    |커스텀 큐      | 모든 QoS 사용 가능 |	Serial/Concurrent 모두 가능 |

# 코드로 이해하기

글로벌 큐와 프라이빗 큐를 직접 코드로 실행해보며 작동 원리를 이해해보겠습니다.

## Global Queue

### sync 함수의 이해

```swift
print("main started ⭐️")

for i in 0...5 {
    DispatchQueue.global().sync {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

// main started ⭐️
// No.0, Thread: <_NSMainThread: 0x10e9efbd0>{number = 1, name = main}
// No.1, Thread: <_NSMainThread: 0x10e9efbd0>{number = 1, name = main}
// No.2, Thread: <_NSMainThread: 0x10e9efbd0>{number = 1, name = main}
// No.3, Thread: <_NSMainThread: 0x10e9efbd0>{number = 1, name = main}
// No.4, Thread: <_NSMainThread: 0x10e9efbd0>{number = 1, name = main}
// No.5, Thread: <_NSMainThread: 0x10e9efbd0>{number = 1, name = main}
// main ended ⭐️
```

코드 결과를 보면 의구심이 드실겁니다. 왜 쓰레드 번호가 1인 메인에서 실행되었을까? 글로벌 큐는 다른 쓰레드에 보내는거 아니었나? 이유는 **sync**에 있습니다. 

sync의 [공식문서](https://developer.apple.com/documentation/dispatch/dispatchqueue/sync%28execute%3A%29-3segw)를 보시면 아래와 같은 설명이 있습니다.

> As a performance optimization, this function executes blocks on the current thread whenever possible, with one exception: Blocks submitted to the main dispatch queue always run on the main thread.

> 성능 최적화를 위해 이 함수는 쓰레드에서 가능하면 작업(block)을 실행시킨다. 단, 메인 디스패치 큐에 보낸 작업은 메인 쓰레드에서 실행된다.

결론, sync는 별도의 쓰레드 생성 및  전송없이 GCD에서 성능 최적화를 위해 호출된 쓰레드에서 작업을 수행할 수 있다.

### global().async

```swift
print("main started ⭐️")

for i in 0...5 {
    DispatchQueue.global().async {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

RunLoop.main.run()

// main started ⭐️
// main ended ⭐️
// No.1, Thread: <NSThread: 0x13d934450>{number = 3, name = (null)}
// No.4, Thread: <NSThread: 0x13dae5060>{number = 6, name = (null)}
// No.3, Thread: <NSThread: 0x1140b0480>{number = 5, name = (null)}
// No.0, Thread: <NSThread: 0x13d843850>{number = 2, name = (null)}
// No.5, Thread: <NSThread: 0x11406e510>{number = 7, name = (null)}
// No.2, Thread: <NSThread: 0x13cf7a1a0>{number = 4, name = (null)}
```

main은 비동기 작업의 종료를 기다리지 않고 종료됩니다. 모든 비동기 작업의 종료를 보지 못하고 코드가 종료되어서 **RunLoop.main.run()** 를 이용하여 코드가 종료되지 않도록 수정했습니다.

### QoS에 따른 실행 시간과 쓰레드의 개수

위 실험에서 0부터 5까지 모든 작업이 서로 다른 쓰레드를 배정받았습니다. 그렇다면, *QoS* 를 낮추게 되면 쓰레드의 개수는 어떻게 될까요? 혹은, 더욱 많은 작업을 할당하고 더 높은 *QoS*로  설정하면 몇 개의 쓰레드까지 발행할 수 있을까요? 실험 결과는 아래 Table로 작성해 놓았습니다.

1000 개의 작업을 할당했을 때, QoS에 따라 할당된 쓰레드의 개수입니다.
| QoS |  쓰레드 개수 | 작업 시간 |
| --  | --- | --- |
|  .userInteractive   |   43  |  0.509초 |
| .userInitiated | 17 | 0.583초 |
| .default | 14 | 0.525초 |
| .utility | 23 | 0.514초 |
| .background | 3 | 0.611초 |

결론, QoS가 높아질 수록 쓰레드 개수가 증가하고, 작업 시간이 줄어드는 추세라는 것을 알 수 있습니다.

추가로 작업안에 **sleep(1)** 를 추가하여 의도적으로 실행 시간을 늘리게 된다면 더 많은 쓰레드를 할당하는 것도 보실 수 있습니다.

## PrivateQueue

프라이빗 큐에서도 sync를 쓰게 된다면 실행 쓰레드에서 작업이 할당되는 것을 이제는 유추할 수 있습니다.

```swift
print("main started ⭐️")

for i in 0...5 {
    DispatchQueue(label: "com.private").sync {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

// main started ⭐️
// No.0, Thread: <_NSMainThread: 0x135e88430>{number = 1, name = main}
// No.1, Thread: <_NSMainThread: 0x135e88430>{number = 1, name = main}
// No.2, Thread: <_NSMainThread: 0x135e88430>{number = 1, name = main}
// No.3, Thread: <_NSMainThread: 0x135e88430>{number = 1, name = main}
// No.4, Thread: <_NSMainThread: 0x135e88430>{number = 1, name = main}
// No.5, Thread: <_NSMainThread: 0x135e88430>{number = 1, name = main}
// main ended ⭐️
```

비동기 작업을 실행했을 때, 어떻게 되는지 보겠습니다.

```swift
print("main started ⭐️")

for i in 0...5 {
    DispatchQueue(label: "com.private").async {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

RunLoop.main.run()

// main started ⭐️
// main ended ⭐️
// No.0, Thread: <NSThread: 0x157731480>{number = 2, name = (null)}
// No.1, Thread: <NSThread: 0x157731480>{number = 2, name = (null)}
// No.2, Thread: <NSThread: 0x157731480>{number = 2, name = (null)}
// No.3, Thread: <NSThread: 0x157731480>{number = 2, name = (null)}
// No.4, Thread: <NSThread: 0x157731480>{number = 2, name = (null)}
// No.5, Thread: <NSThread: 0x157731480>{number = 2, name = (null)}
```

프라이빗 큐는 기본적으로 순서 큐 이기 때문에 하나의 쓰레드로만 보내어 순서가 보장됩니다. 그리하여 순서가 보장된 결과를 볼 수 있습니다.

이상, 큐의 종류, QoS, 작업의 종류를 조합해 가며 코드를 작성하고 실험을 통해 개념을 알아봤습니다. 도움이 되셨기를 바라며 피드백은 언제나 환영입니다.

참고 자료

앨런 iOS Concurrency(동시성)

https://www.inflearn.com/course/ios-concurrency-gcd-operation/dashboard

애플 공식문서

https://developer.apple.com/documentation/dispatch/dispatchqueue

https://developer.apple.com/documentation/dispatch/dispatchqueue/global(qos:)

https://developer.apple.com/documentation/dispatch/dispatchqueue/init(label:qos:attributes:autoreleasefrequency:target:)