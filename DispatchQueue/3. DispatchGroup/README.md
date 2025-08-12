# Overview

비동기 작업 A, B, C가 있다고 가정해보겠습니다. 이 모든 작업을 병렬 처리로 작업을 실행시키고 나서 모든 작업이 종료되는 시점을 알아야 한다면 어떻게 해야할까요? `DispatchGroup`을 사용하면 위와 같은 요청 사항을 처리할 수 있습니다.

## 반드시 사진 제작 후, 첨부

[공식문서](https://developer.apple.com/documentation/dispatch/dispatchgroup)
> A group of tasks that you monitor as a single unit.

공식문서에서는 하나의 유닛처럼 작업 그룹을 모니터링할 수 있다고 말합니다.

작업 그룹이 시작, 실행, 종료 등에 대한 동작을 지정할 수 있습니다. 또한 어떤 작업 그룹이 N초 이상 걸리는 경우 강제로 실행을 종료할 수 있습니다.

# DispatchGroup

## Basic (notify)

기본적으로 어떻게 코드로 작성하여 사용하는지 알아보겠습니다.

1. `DispatchGroup` 클래스를 선언해줍니다.

`let group1 = DispatchGroup()`

2. sync/async 함수의 매개변수로 group이 존재합니다. 여기에 선언해준 DispatchGroup 인스턴스를 할당합니다.

```swift
DispatchQueue.global().async(group: group1){ // group1에 작업을 할당
    // 작업
}
```


3. 작업 그룹의 내용이 모두 끝난 경우를 알고 이후 동작을 지정하려는 경우, DispatchGroup 인스턴스의 notify(queue: )`를 호출합니다.
`queue`는 어떤 DispatchQueue에서 실행할지 정하는 매개변수입니다.

```swift
let group1 = DispatchGroup()
DispatchQueue.global().async(group: group1){
    sleep(1)
    print("Task1 Completed")
}
DispatchQueue.global().async(group: group1){
    sleep(2)
    print("Task2 Completed")
}
DispatchQueue.global().async(group: group1){
    sleep(1)
    print("Task3 Completed")
}

group1.notify(queue: DispatchQueue.main){
    print("All Tasks Completed")
}
```

Task3 Completed

Task1 Completed

Task2 Completed

All Tasks Completed

그룹 내의 모든 작업이 종료된 이후 All Task Completed 구문이 출력되는 것을 보실 수 있습니다.

notify()는 작업을 그룹 종료 이후에 실행될 수 있게 스케줄링합니다. 즉, 비동기적으로 실행할 수 있게 한다고 생각하시면 됩니다.

## wait()

wait()가 실행되면 그룹이 완료될때까지 현재 대기열(쓰레드)을 차단합니다. 즉, 그룹의 종료를 동기적으로 기다립니다. 

위 코드에서 아래 코드를 추가하고 실행해보겠습니다.

```swift
global.async {
    print("wait started")
    group1.wait()
    print("wait ended")
}
```

결과

wait started

Task1 Completed

Task3 Completed

Task2 Completed

All Tasks Completed

wait ended

비동기적으로 다른 쓰레드에서 "wait started" 구문이 출력된 이후, 이 작업은 group1의 종료를 기다리는 상태가 됩니다. 그룹의 종료 이후, 바로 wait ended가 실행됩니다.

쓰레드를 강제로 대기상태에 만든다는 뜻은 메인 쓰레드에서 실행되면 안됩니다. 그렇다면 UI가 멈춘 것처럼 나타날 것입니다.

## wait(timeout:) -> DispatchTimeoutResult

작업을 기다렸는데 원하는 시간 내에 작업이 완료되었는지 여부를 판단해야하는 경우 사용합니다.

```swift
switch group1.wait(timeout: .now() + 2) {
case .success:
    print("succeeded")
case .timedOut:
    print("timedOut")
}
```

- success : 예정된 시각 전에 종료된 경우를 의미합니다.

- timeOut : 예정된 시각 전에 종료되지 않은 경우를 의미합니다. 그룹의 종료를 강제하지는 않습니다.

## enter() / leave()

코드 예시와 함께, 문제 상황을 하나 가정하겠습니다. 그룹 내에 비동기 작업이 종료되기 전에 그룹이 종료되어 문제가 발생한다면 어떻게 방지해야할까요? 

```swift
global.async(group: group1) {
    print("Sync Task A Completed")
    global.async {
        sleep(2)
        print("Async Task X Completed")
    }
    print("Sync Task B Completed")
}

group1.notify(queue: .main) {
    print("All Tasks Completed")
}
```

출력

Sync Task A Completed

Sync Task B Completed

All Tasks Completed : 그룹이 종료

Async Task X Completed : 그룹 내의 비동기 작업이 종료

- 그룹 내의 모든 작업이 완료되지 않았음에도 완료되었다는 출력이 비동기 보다 먼저 출력되었습니다.

enter()와 leave()를 이용해서 비동기 작업을 그룹 종료조건에 포함시키는 방법이 있습니다.

반드시 짝이 맞아야 하며, 그렇지 않으면 런타임 에러가 발생할 수 있습니다.

아래 예시 코드로 문제 상황을 해결해보겠습니다.

```swift
global.async(group: group1) {
    print("Sync Task A Completed : \(Thread.current)")
    group1.enter()
    global.async {
        sleep(2)
        print("Async Task X Completed : \(Thread.current)")
        group1.leave()
    }
    print("Sync Task B End : \(Thread.current)")
}

group1.notify(queue: .main) {
    print("All Tasks Completed : \(Thread.current)")
}
```

출력

Sync Task A Completed

Sync Task B Completed

Async Task X Completed

All Tasks Completed

- 그룹 내의 모든 작업을 완료한 이후 notify() 가 실행됩니다.

참고 자료

https://developer.apple.com/documentation/dispatch/dispatchgroup

https://developer.apple.com/documentation/dispatch/dispatchgroup/notify(qos:flags:queue:execute:)

https://developer.apple.com/documentation/dispatch/dispatchgroup/wait()

