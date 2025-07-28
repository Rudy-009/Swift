# Overview

들어가기에 앞서 기본적인 용어를 정리하고 들어가보겠습니다.

```swift
DispatchQueue.main().async {
	// 작업
}
```
- 코드 1

# 작업 (Task)
코드 1에서 { } 안의 실행되는 코드를 말합니다. 동기 비동기 등을 정하기 전에 어떤 동작을 수행할지 정해야겠죠? 그게 바로 작업입니다. swift가 발전하며 `async/await`가 소개되며 `Task`도 추가되었습니다. 이 `Task`와는 관련이 없습니다.

# 큐 or 대기행렬(Queue)
작업이 본인의 쓰레드를 배정받기 전까지 대기하는 장소입니다. 여기서 큐의 종류에 따라 배정되는 쓰레드가 결정됩니다.

## 쓰레드 (Thread)
'작업 흐름의 단위' 라고 정의되어 있습니다. 우선, 이 곳에 작업이 배치되면 실행된다고 생각하시면 좋습니다.

## 디스패치큐 (DispatchQueue)
영어 문장으로 코드를 해석해 본다면. Dispatch는 4형식 동사입니다. Dispatch A B, 'B를 A에게로 전송하라' 라는 명령문 입니다. 큐에 작업을 보내라! 라는 명령문이죠.

```swift
DispatchQueue.main().async {
	// 작업
}
```
코드1을 다시 볼까요? Dispatch Main Queue Asynchronous Task.

'비동기 작업을 메인 큐에 전송하라'입니다.

형용사 혹은 명사로 설명을 추가로 해서 DispatchQueue를 구체화 하는게 보이시나요? 

후에 나올 내용들을 코드로 나타낸다면 다음과 같습니다.

```swift
DispatchQueue.{큐 종류}({QoS}).{async/sync} {
	// 작업
}
```

아래 테이블은 Queue의 유형별로 고정된 값을 정리했습니다.
|Queue 유형	| 특징 |	QoS 제약 |	큐 유형 제약 |
| --       | --- | --- | --- |
|main       |UI 스레드 전용  | .userInteractive 고정| 	Serial(순서) 고정 |
|global     |시스템 글로벌 큐 |	모든 QoS 사용 가능 |	Concurrent(동시) 고정 |
|private    |커스텀 큐      | 모든 QoS 사용 가능 |	Serial/Concurrent 모두 가능 |

```swift
DispatchQueue.main.sync {
    // 작업
}
```
 에러가 발생합니다. main이 어떤 작업이 끝나기를 기다리는 것은 매우 위험합니다. 다른 중요한 작업들이 많기 때문이죠.

메인 큐는 UI를 그리는 작업을 하기 때문에 다른 작업이 지연되는 것을 지양합니다. UI 작업이 느려지면 사용자는 앱이 고장난것으로 간주할 수 있기 때문이죠, 그래서 작업이 오래 걸리는 경우 비동기 작업으로 빼는 것입니다.

## 비동기 (Asynchronous)
작업을 실행시킨 후, 그 작업이 끝나기를 기다리지 않고 다음 일을 진행하는 것을 의미합니다.

좀 더 풀어서 설명하자면 쓰레드1에서 작업 X를 수행하던 도중 작업 Y를 비동기적으로 실행시켰습니다. 그러면 작업 Y는 쓰레드2로 넘어가서 실행되고 쓰레드1은 작업 Y의 종료를 기다리지 않고 작업 X를 계속해서 실행하게 됩니다.

## 동기 (Synchronous)
동기는 반대로 작업을 실행시킨 후, 그 작업이 끝나기를 기다린다는 의미이겠죠. 저희가 평소에 쓰던 코드가 동기적이었던 코드였습니다.

# 순서 큐 (Serial Queue)
큐에 대기중인 작업을 모두 같은 쓰레드로 보냅니다. 큐에 들어온 순서대로 작업들이 실행 될 것입니다.

# 동시 큐 (Concurrent Queue)
큐에 대기중인 작업을 모두 다른 쓰레드로 보냅니다. 그렇다면 각자의 Thread에서 작업이 실행되겠죠.

다음 글에서는 예시 코드를 통해 어떻게 DispatchQueue가 작업을 수행하는지 알아보겠습니다.

참고 자료

앨런 iOS Concurrency(동시성)
https://www.inflearn.com/course/ios-concurrency-gcd-operation/dashboard