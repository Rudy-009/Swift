# Concurrency
> Perform asynchronous operations.

## Concurrency vs Parrell 

Concurrency
- 여러 작업을 번갈아가며 실행하는 것으로, 실제로는 동시에 실행되지 않을 수 있다. (너무 빨라서 그렇게 보임)

Parallelism
- 실제로 여러 작업이 다른 CPU 코어에서 동시에 실행되는 것

# Keywords

## Basics
- async/await: 비동기 함수를 정의하고 호출하는 Swift의 기본 키워드
- Task: 동시성 작업의 기본 단위로, 실행, 우선순위 및 관리를 담당하는 객체
- Actor: 데이터 경쟁을 방지하고 상태를 안전하게 관리하는 참조 타입
- Sendable Type :

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

# 

async : 비동기 함수임을 알려주는 키워드
규칙 : 함수 선언에서 -> 바로 이전에 쓴다. (throw가 있으면 throw 이전에)
예시 : func download() async throw -> ...

await : async 함수를 호출할 때, 앞에 붙여주는 키워드
예시 : await download() 

await는 이 함수의 동작이 완료된 이후에 다음 코드를 실행하라는 명령어로 동시성을 제어한다.