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

# Defining and Calling Asynchronous Function

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


# Calling Asynchronous Function in Parallel

- *async let* : 비동기 작업을 병렬적으로 처리할 수 있게 해준다.

```swift
let firstImage = await loadImage(index: 1) // 이 코드가 끝나야지만 아래 코드가 실행된다.
let secondImage = await loadImage(index: 2)
let thirdImage = await loadImage(index: 3)
```

```swift
async let firstImage = loadImage(index: 1)
async let secondImage = loadImage(index: 2)
async let thirdImage = loadImage(index: 3)
let images = await [firstImage, secondImage, thirdImage]
```
- 사진을 불러오는 위 코드는 모두 병렬적으로 실행된다.
