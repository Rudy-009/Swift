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

# Keywords

## Basics
- async/await: 비동기 함수를 정의하고 호출하는 Swift의 기본 키워드
- Task: 동시성 작업의 기본 단위로, 실행, 우선순위 및 관리를 담당하는 객체
- Actor: 데이터 경쟁을 방지하고 상태를 안전하게 관리하는 참조 타입
- Sendable Type: 

## Environment
- Main Thread: UI 업데이트를 담당하는 주 실행 스레드
- Cooperative Thread Pool: CPU 코어 수에 맞춰 제한된 동시성 작업을 실행하는 스레드 풀

## Concurrenty Pattern
- Structured Concurrency: 부모-자식 관계로 구성된 계층적 태스크 구조
- Unstructured Concurrency: 독립적으로 실행되는 단독 태스크 구조
- Task Group: 관련된 동시성 작업들을 그룹으로 관리하는 구조

## Safety
- Data Race: 
- Reentrancy: 
- Critical Section: 