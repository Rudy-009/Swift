# Overview

본격적으로 시작하기 전에, 먼저 기본 용어들을 정리해볼게요.
DispatchQueue를 공부하면서 꼭 알아야 할 중요한 개념들이니, 잘 이해하고 넘어가면 좋겠습니다.

```swift
DispatchQueue.main.async {
	// 작업
}
```
- 코드 1
- 이 코드를 시작으로 DispatchQueue에 대해 궁금해서 공부를 시작했습니다 그런데, 막상 시작하니 너무 어려웠습니다. 이유는 용어를 제대로 정리하지 않고 시작해서 그랬던거 같아요. 이 글을 읽으시는 분들은 적어도 용어는 헷갈리지 않으셨으면 하는 마음에 작성하게 되었습니다.

# GCD
- Grand Central Dispatch

공식문서
> Dispatch, also known as Grand Central Dispatch (GCD), contains language features, runtime libraries, and system enhancements that provide systemic, comprehensive improvements to the support for concurrent code execution on multicore hardware in macOS, iOS, watchOS, and tvOS.

GCD란? 언어 기능, 런타임 라이브러리, 시스템 개선 사항을 포함하여 멀티코어 하드웨어에서 동시적 코드를 지원하는 기술을 말한다. 즉, GCD는 하나의 개념이고 DispatchQueue는 이를 구현한 구현체로 보는게 맞습니다. (Map과 HashMap의 관계처럼)

과거에는 개발자가 직접 쓰레드를 관리했습니다. 멀티쓰레딩은 복잡하고 에러가 많이 발생해서 해결하고자 등장한 개념이 바로 GCD입니다.

# 작업 (Task)
코드 1에서 { } 안의 실행되는 코드를 말합니다. 동기 비동기 등을 정하기 전에 어떤 동작을 수행할지 정해야겠죠? 그게 바로 작업입니다. swift가 발전하며 `async/await`가 소개되며 `Task`도 추가되었습니다. 이 `Task`와는 관련이 없습니다.

# 큐 or 대기행렬(Queue)
작업이 본인의 쓰레드를 배정받기 전까지 대기하는 장소입니다. 여기서 큐의 종류에 따라 배정되는 쓰레드가 결정됩니다.

# 쓰레드 (Thread)
'작업 흐름의 단위' 라고 정의되어 있습니다. 우선, 이 곳에 작업이 배치되면 실행된다고 생각하시면 좋습니다.

# 디스패치큐 (DispatchQueue)

공식문서에서 DispatchQueue를 다음과 같이 정의하고 있습니다.

공식문서
> An object that manages the execution of tasks serially or concurrently on your app’s main thread or on a background thread.

앱의 메인 혹은 다른 쓰레드에서 작업들의 실행을 관리하는 객체(클래스)입니다.

저희가 앞으로 많이 보게될 단어입니다. DispatchQueue 객체를 통해 다양한 종류의 작업을 메인 혹은 백그라운드 쓰레드에서 작동하게 해줍니다. 이로써 개발자는 어느 쓰레드에 등록할지, 얼마나 많은 쓰레드를 사용해야 하는지 등의 고민에서 벗어나게 됩니다.

# 비동기 (Asynchronous)
작업을 실행시킨 후, 그 작업이 끝나기를 기다리지 않고 다음 일을 진행하는 것을 의미합니다.

좀 더 풀어서 설명하자면 쓰레드1에서 작업 X를 수행하던 도중 작업 Y를 비동기적으로 실행시켰습니다. 그러면 작업 Y는 쓰레드2로 넘어가서 실행되고 쓰레드1은 작업 Y의 종료를 기다리지 않고 작업 X를 계속해서 실행하게 됩니다.

# 동기 (Synchronous)
동기는 반대로 작업을 실행시킨 후, 그 작업이 끝나기를 기다린다는 의미이겠죠. 저희가 평소에 쓰던 코드가 동기적이었던 코드였습니다.

# 순서 큐 (Serial Queue)
큐에 대기중인 작업을 모두 같은 쓰레드로 보냅니다. 큐에 들어온 순서대로 작업들이 실행 될 것입니다. 이를 '순서를 보장한다'라고도 합니다.

# 동시 큐 (Concurrent Queue)
큐에 대기중인 작업을 모두 다른 쓰레드로 보냅니다. 그렇다면 각자의 Thread에서 작업이 실행되겠죠. 작업의 순서를 보장하지 않습니다.

# QoS (Quality of Service)

공식문서
> Quality-of-service classes that specify the priorities for executing tasks.

작업 수행의 우선순위를 구체화하는 클래스

| 종류 | 설명 |
| --- | --- |
| userInteractive | 사용자 상호작용과 연관된 작업(애니메이션, 이벤트 처리, UI 업데이트) |
| userInitiated | 즉시 필요하지만, 비동기족으로 처리된 작업 |
| default | 일반적인 작업 |
| utility |  Progress Indicator와 함께 길게 실행되는 작업 |
| background |  유저가 직접적으로 인지하지 않는 작업 |
| unspecified | legacy API 지원 |

QoS가 높을 수록 더 많은 쓰레드를 할당하여 코드를 빨리 실행시킨다.

다음 글에서는 예시 코드를 통해 어떻게 DispatchQueue가 작업을 수행하는지 알아보겠습니다.

참고 자료

앨런 iOS Concurrency(동시성)

https://www.inflearn.com/course/ios-concurrency-gcd-operation/dashboard