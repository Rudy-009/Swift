# Overview

`DispatchWorkItem`은 블록, 클로저 형태에 넣은 작업을 클래스화한 것입니다.

> The work you want to perform, encapsulated in a way that lets you attach a completion handle or execution dependencies.

"수행하려는 작업을 컴플리션 핸들러나 의존성을 붙일 수 있게 캡슐화한 것" 이라고 해석할 수 있습니다. 의존성이라는 단어가 헷갈릴 수 있지만 여기서는 "순서를 관리한다"라고 생각하시면 좋을거 같습니다.

# DispatchWorkItem

```swift
let item = DispatchWorkItem(qos: .utility)  {
    // 작업 내용
}
```

- qos를 설정해서 생성할 수 있습니다.

```swift
DispatchQueue.global().async(execute: item)

item.perform()
```

- Queue에 보내서 실행할 수 있고, perform() 메서드로 해당 쓰레드에서 바로 실행시킬 수도 있습니다.

# 취소

```swift
item.cancel()
```

- 이 함수는 작업의 상태에 따라 기능이 달라집니다. 

1. 실행 이전, 작업을 실행하면 바로 반환합니다. 즉, 작업이 삭제됩니다.

2. 실행 중, `isCancelled` 의 값이 `true`로만 바뀌고 작업 실행이 취소되지는 않습니다.

직접 실행시켜서 결과를 확인해보겠습니다.

```swift
item1.cancel()

global.async(execute: item1)
global.async(execute: item2)
usleep(10) // 10 마이크로초, 
// item2가 실행상태에 들어가기 전에 아래 코드가 먼저 실행되는 것을 방지
item2.cancel()
```

실행 결과는 item2만 실행되고 item1의 결과는 출력되지 않는 것을 확인하실 수 있을겁니다.

# 순서 기능

```swift
item1.notify(queue: global, execute: item2)
```

item1이 끝난 이후에 item2가 실행되는 코드입니다.

참고 자료

[앨런 iOS 앨런 iOS Concurrency(동시성)](https://www.inflearn.com/course/ios-concurrency-gcd-operation/dashboard)

[DispatchWorkItem 공식문서](https://developer.apple.com/documentation/dispatch/dispatchworkitem)
