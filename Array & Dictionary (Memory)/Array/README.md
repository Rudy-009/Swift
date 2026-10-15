![](https://velog.velcdn.com/images/rudy009/post/d2355a4f-091b-42ad-9527-1e0e87fd1d88/image.png)

# Array는 struct인데, 어떻게 저장되는가?

Array는 분명 struct인데, 요소를 아무리 많이 넣어도 변수 자체는 커지지 않습니다. 왜일까요?

```swift
var a = [1, 2, 3, 4]
print(MemoryLayout.size(ofValue: a)) // 8
print(a.count, a.capacity)           // 4 4
```

- 64비트 플랫폼에서 Array 변수의 크기는 항상 8바이트입니다.
- struct 안에 들어 있는 건 요소가 아니라, 힙에 있는 **버퍼 객체(클래스 인스턴스)의 주소** 하나뿐입니다.

![](https://velog.velcdn.com/images/rudy009/post/1b225f4d-8e47-48df-8c96-b06957c9ed0d/image.png)

요소들은 저 버퍼 안에 연속으로 들어가고, 그 앞에 헤더가 붙습니다.

- header : 32바이트 (64비트 기준)
  - 메타데이터 포인터 8 + 리퍼런스 카운트 8
  - count 8
  - capacity 8
- `count` 는 실제로 채워진 요소의 수, `capacity` 는 재할당 없이 담을 수 있는 요소의 수입니다.


## reserveCapacity(_ : Int)

담을 원소 수를 미리 알고 있다면 `reserveCapacity(_:)` 로 버퍼를 먼저 확보해서, 중간에 일어나는 재할당을 없앨 수 있습니다.

- 최대 크기가 아니라 **최소 보장 용량** 입니다. 넘겨준 값보다 capacity가 더 커질 수 있습니다.
- 버퍼를 다른 배열과 공유하고 있다면, 이 호출 자체에서 복사가 일어납니다.

# append() 했을 때, capacity를 넘어간다면?

버퍼는 고무줄처럼 늘어나지 않습니다. capacity를 넘기는 순간 저희가 쓰던 버퍼는 버려집니다.

1. 더 큰 버퍼를 새로 할당합니다.
2. 기존 값을 전부 새 버퍼로 복사합니다.
3. 새 값을 추가합니다.

이 세 단계는 모두 같은 `append` 호출 안에서 끝납니다. 그리고 2번 때문에 재할당이 한 번 일어날 때의 비용은 O(N) 입니다.

여기서 질문을 하나 던져보겠습니다. 만약 요소를 추가할 때마다 매번 재할당한다면 어떻게 될까요? 추가할 때마다 N번 복사를 하니 전체가 O(N²) 가 되어버립니다.

그래서 Swift는 capacity를 **2배씩** 키웁니다. 그러면 n개를 넣는 동안 일어나는 복사의 총량이

```
n + n/2 + n/4 + … < 2n
```

이 되고, 삽입 하나당 평균 비용은 O(1) 로 떨어집니다. 이걸 분할 상환 분석 (Amortized Analysis) 이라고 부릅니다.

말로만 보면 와닿지 않으니 직접 돌려보겠습니다. 빈 배열에 요소를 하나씩 넣으면서, capacity가 이전과 달라지는 순간만 출력해봤습니다.

```swift
var a: [Int] = []
print(a.count, a.capacity)

var capacity = a.capacity

for i in 1...50 {
    a.append(i)
    if capacity != a.capacity {
        print(a.count, a.capacity)
        capacity = a.capacity
    }
}

// 0 0
// 1 2
// 3 4
// 5 8
// 9 16
// 17 36
// 37 76
```

- 왼쪽이 count, 오른쪽이 그때의 capacity 입니다.
- 대략 2배씩 커지는 규칙은 보입니다.

그런데 코드 결과를 보면 의구심이 드실 겁니다. 2배라면서 16 다음이 왜 32가 아니라 36일까요?

## 16 다음은 왜 32가 아니라 36일까?

정확한 규칙은 2배가 **요청하는 값** 이라는 데에 있습니다. 표준 라이브러리는 `max(필요한 최소 용량, 이전 capacity × 2)` 만큼을 요청하고, 실제 버퍼는 거기서 **할당자가 한 번 더 올림한 크기** 로 잡힙니다.

그리고 Array는 그렇게 확보된 바이트를 버리지 않고, 다시 capacity로 환산합니다.

```
capacity 16 → 32개를 요청
요청 바이트 = 헤더 32 + 32 × 8 = 288
malloc_good_size(288) = 320
실제 capacity = (320 - 32) / 8 = 36
```

정말 할당자가 올리는 게 맞는지 확인해보겠습니다.

```swift
import Darwin

for req in [288, 320, 608, 640] {
    print(req, "->", malloc_good_size(req))
}

// 288 -> 320
// 320 -> 320
// 608 -> 640
// 640 -> 640
```

- 288바이트를 요청하면 할당자는 320바이트를 내어줍니다.
- 남는 32바이트는 `Int` 4개가 들어갈 공간이고, 그래서 capacity가 32가 아니라 36이 됩니다.

실제 버퍼의 크기도 `malloc_size` 로 직접 찍어볼 수 있습니다.

```swift
// count 1  cap 2   malloc_size 48
// count 3  cap 4   malloc_size 64
// count 5  cap 8   malloc_size 96
// count 9  cap 16  malloc_size 160
// count 17 cap 36  malloc_size 320
// count 37 cap 76  malloc_size 640
```

**결론, 2배를 계산하는 쪽은 표준 라이브러리이고, 올림을 하는 쪽은 할당자입니다.** 36, 76 같은 어중간한 숫자는 버그가 아니라 남는 공간을 알뜰하게 쓴 결과라고 이해하시면 될 것 같습니다.

참고로 50개까지만 돌려서 76에서 멈췄는데, 더 돌려보시면 156, 316으로 이어지는 것도 보실 수 있습니다.

# Copy-on-Write

Array는 값 타입입니다. 그렇다면 배열을 다른 변수에 할당할 때마다 요소를 전부 복사할까요? 요소가 백만 개라면 그때마다 백만 번을 복사해야 할 텐데, 다행히 그렇지 않습니다.

![](https://velog.velcdn.com/images/rudy009/post/6ae59b63-c81a-42a4-9407-ad6cfba3eb6a/image.png)

b에 a를 할당해도 복사는 일어나지 않습니다. 둘은 같은 버퍼를 가리키고, 리퍼런스 카운트만 2가 됩니다.

복사를 유발하는 건 '변경' 자체가 아니라 **버퍼를 혼자 쓰고 있지 않은 상태에서의 변경** 입니다. 이때 변경을 시도한 쪽이 새 버퍼를 복사해서 받아가고, 다른 쪽은 원래 버퍼에 그대로 남습니다.

직접 주소를 찍어서 확인해보겠습니다.

```swift
func addr(_ x: [Int]) -> UnsafeRawPointer {
    x.withUnsafeBufferPointer { UnsafeRawPointer($0.baseAddress!) }
}

var a: [Int] = [1, 2, 3]
print(addr(a))
var b = a
print(addr(b))
b.removeLast()
print(addr(a))
print(addr(b))

// 0x00000001022b80b0 : a 첫 요소의 주소
// 0x00000001022b80b0 : b 첫 요소의 주소 (할당만 했을 땐 같습니다)
// 0x00000001022b80b0 : a 첫 요소의 주소 (그대로입니다)
// 0x000000010299a750 : b 첫 요소의 주소 (달라졌습니다)
```

- 변경을 시도한 b가 새 버퍼를 받아갔고, a는 원래 버퍼에 그대로 남았습니다.
- 반대로 a를 먼저 변경했다면, 새 버퍼를 받는 쪽은 a가 됩니다.

반대로 버퍼를 혼자 쓰고 있다면 변경해도 복사하지 않고 그 자리에서 바꿉니다. 이 조건은 `isKnownUniquelyReferenced` 로 판단합니다.

```swift
var c: [Int] = []
for i in 1...3 { c.append(i) }
let before = addr(c)

c.removeLast()
print(before == addr(c)) // true

c[0] = 99
print(before == addr(c)) // true
```

**결론, 복사의 기준은 "변경했는가" 가 아니라 "혼자 쓰고 있는가" 입니다.**

그런데 이 실험을 할 때 한 가지 주의할 점이 있습니다. 저는 처음에 `var c: [Int] = [1, 2, 3]` 으로 테스트했다가 혼자 쓰고 있는데도 주소가 바뀌어서 한참을 헤맸습니다.

`-O` 로 최적화하면 배열 리터럴이 정적 메모리에 놓일 수 있어서, 혼자 쓰고 있어도 첫 변경에서 새 버퍼가 잡히더군요. 그래서 위 코드처럼 `append` 로 채운 배열을 써야 제자리 변경을 확인하실 수 있습니다. 제 개인적인 생각으로는, 리터럴 배열이 읽기 전용 영역에 있어서 그대로 쓸 수 없기 때문이라고 이해됩니다.


참고 자료

[Array.swift - swiftlang/swift](https://github.com/swiftlang/swift/blob/main/stdlib/public/core/Array.swift)

[이 글의 예제 코드: 직접 돌려보시면 capacity 숫자가 더 잘 와닿습니다](https://github.com/Rudy-009/Swift/tree/main/Array%20%26%20Dictionary%20(Memory)/Array)

부족한 부분이나 틀린 내용이 있다면 **피드백은 언제나 환영입니다.** 감사합니다.
