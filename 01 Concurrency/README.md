# Concurrency
> Perform asynchronous operations.

# Introduction

## Thread
- 프로세스 내에서 실제로 작업을 수행하는 주체.
- Swift에서는 Thread를 자동으로 관리하기 때문에, **프로그래머는 단순히 비동기 작업 (async/await)을 정의, 실행 순서 지정만 하면 된다.**

**Thread Pool**
> Thread를 생성하고 재사용하는 효율적인 시스템
- Swift에서 GCD(Grand Central Dispatch)를 통해 Thread Pool을 관리한다.

## Concurrency vs Parallelism

**Concurrency**
- 여러 작업이 빠르게 번갈아 실행되는 것. (Context Switching)
- Single-Core

**Parallelism**
- 실제로 여러 작업이 다른 CPU 코어에서 동시에 실행되는 것
- Multi-Core

![](ConcurrencyVSParallelism.png)

## Synchronous vs Asynchronous

**Synchronous**
- 작업을 순차적으로 실행된다. (직렬) 이전 작업이 완료될 때까지 다음 작업을 기다린다. 코드의 실행 흐름이 예측 가능하고 단순하다.

**Asynchronous**
- 작업들이 서로 독립적으로 실행된다. (병렬), 동시에 여러 작업을 처리할 수 있다. 한 작업이 완료되기를 기다리는 동안 다른 작업을 수행할 수 있어 효율적이다.

- Q. 그럼 Single-Core 환경에서 Asynchronous하게 실행할 수 있는가?
- A. Conext Switching을 통해 여러 쓰레드를 번갈아 가며 실행하여 마치 여러 작업들이 동시에 실행되는 것처럼 구현할 수 있다.

- async/await: 비동기 함수를 정의하고 호출하는 Swift의 기본 키워드
- Task: 동시성 작업의 기본 단위로, 실행, 우선순위 및 관리를 담당하는 객체
- Actor: 데이터 경쟁을 방지하고 상태를 안전하게 관리하는 참조 타입

#  Asynchronous Function

## Defining and Calling Asynchronous Function

- *async* : 비동기 함수임을 알려주는 키워드
    - 함수 시그니처에서 () 다음 -> 전에 쓰면 된다. *throw*가 있으면 앞에 붙여주면 된다.
    
- *await* : 비동기 함수를 실행하려 할 때 앞에 쓴다.
    - try 뒤 함수 이름 앞에 쓴다.

```swift
func fetchUserData() async throws -> User {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
    return User(id: 1, name: "John")
}
```

- *for-await-in loop* : 를 이용하여 for문 안에서 이미지를 비동기적으로 불러올 수 있다.
- Sequence Protocol을 체택하여 for-in loop안에서 반복할 수 있게 했던것 처럼 AsyncSequence Protocol을 체택하면 된다.

```swift
import Foundation

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}
```

## Calling Asynchronous Function in Parallel

- *async let* : 비동기 작업을 병렬적으로 처리할 수 있게 해준다.

```swift
let firstPhoto = await loadPhoto(index: 1) // 이 코드가 끝나야지만 아래 코드가 실행된다.
let secondPhoto = await loadPhoto(index: 2)
let thirdPhoto = await loadPhoto(index: 3)
let photos = [firstPhoto, secondPhoto, thirdPhoto]
```

```swift
async let firstImage = loadImage(index: 1)
async let secondImage = loadImage(index: 2)
async let thirdImage = loadImage(index: 3)
let images = await [firstImage, secondImage, thirdImage]
```
- 사진을 불러오는 위 코드는 모두 병렬적으로 실행된다.

# Task & Task Groups

## Task
> A task is a unit of work that can be run asynchronously as part of your program.

프로그램에서 비동기적으로 실행되는 작업 단위. 여러가지 Task를 만들게 되면, Swift에서는 동시에 Task를 돌리게 된다.

## Task Groups

Task는 부모 Task가 있으며, 자식 Task를 가질 수 있다.


## Task Cancellation

```swift
await withTaskGroup(of: Data.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }

    for await photo in group {
        show(photo)
    }
}
```

- group.addTask : 새로운 Task를 Task Group에 추가한다.
- for await photo in group : Task가 먼저 종료되는 순서로 show(photo) 가 실행된다.

```swift
let photos = await withTaskGroup(of: Data.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }

    var results: [Data] = []
    for await photo in group {
        results.append(photo)
    }

    return results
}
```
- 사진이 개별 Task가 종료되는 대로 show(photo)가 호출 되었던 코드와 달리 모든 사진이 다운되면 [Data]를 반환하고 종료된다.

## Task Cancellation
- 각 Task는 취소가 적절한 때에 이루어졌는지 판단하고, 취소에 적절하게 대응한다.
- Cancellation의 의미는 주로 다음과 같다.
    - Throw CancellationError
    - Returning nil or empty collection
    - Returning the partially completed work

## How to Cancele

1. Task.checkCancellation() -> Bool 호출

2. Task.isCancelled: Bool 읽기

```swift
if Task.checkCancellation() {
    // Cancelled
} 

guard Task.isCancelled else {return nil}
```

# Structed Concurrency & Unstructed Concurrency

## Structured Concurrency
- Task는 모두 부모가 있고, 자식을 가질 수 있다. 이런 접근을 Structed Concurrency 라고 한다.

### 장점
1. 부모 Task에서 자식 Task가 끝나는 것을 놓치는 것을 방지할 수 있다.
2. 자식 Task에 더 우선시 되는 Task를 추가하면 부모 Task는 자동적으로 더 높은 우선순위를 갖는다.
3. 부모 Task가 취소(canceled)되면 자식 Task도 자동으로 취소된다.
4. 부모 Task-local의 값이 효율적으로 자식 Task에 전파된다.

## Unstructed Concurrency

- Task에 부모가 없다.
- Task.init()으로 직접 생성한다.
- 직접 detarched()를 호출하여 작업 종료를 알려야 한다.