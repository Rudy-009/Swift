# Overview

SwiftData를 쓰다가 `insert` 메서드의 정의를 보게 되었습니다.

```swift
func insert<T>(_ model: T) where T : PersistentModel
```

여기서 의문이 하나 생겼습니다. 왜 굳이 Generic을 썼을까요? 아래처럼 정의하면 더 간단해 보이는데 말이죠.

```swift
func insert(_ model: any PersistentModel)
```

이 질문 하나를 파고들다 보니 `associated type`, `witness`, `existential type`, `opaque type` 같은 단어들이 줄줄이 따라 나왔습니다. 그리고 예전에 DispatchQueue를 공부할 때와 똑같은 실수를 반복하고 있다는 걸 깨달았습니다. 용어를 정리하지 않고 시작한 것이죠.

그래서 이번에도 용어부터 정리하고 넘어가려 합니다. 이 글에서는 앞으로 계속 나올 단어들만 짚고, 각각의 자세한 내용은 다음 글들에서 다뤄보겠습니다.

# 프로토콜 요구사항 (Requirement)

프로토콜이 "이건 꼭 구현해라"라고 적어둔 목록입니다. 메서드, 프로퍼티, 이니셜라이저, 연관 타입 등이 여기에 들어갑니다.

```swift
protocol Producer {
    associatedtype Output
    func produce() -> Output
}
```

- `associatedtype Output` 과 `func produce() -> Output` 이 각각 요구사항입니다.

# 증인 (Witness)

> **witness**
> 프로토콜 요구사항을 충족하는 구체적인 선언

단어 그대로 해석하면 '증인'입니다. "이 타입이 프로토콜을 정말 따르고 있다"는 것을 증명해주는 실제 구현부라고 생각하시면 좋을거 같습니다.

```swift
struct S: Producer {
    func produce() -> Int {
        return 10
    }
}
```

witness는 두 종류로 나뉩니다.

| 종류 | 설명 | 위 코드에서 |
| --- | --- | --- |
| **value witness** | 메서드·프로퍼티 요구사항을 충족하는 멤버 | `func produce() -> Int` |
| **type witness** | `associatedtype` 요구사항을 충족하는 구체 타입 | `Output` 자리의 `Int` |

여기서 재미있는 점은, `S`는 `Output`이 뭔지 **한 번도 적지 않았다는 것**입니다. 그런데도 `Output == Int`로 정해집니다. 이게 바로 다음에 볼 '추론'입니다.

## 직접 확인해보기

말로만 들으면 잘 와닿지 않으니 컴파일러가 실제로 무엇을 만들어내는지 직접 확인해보겠습니다.

```bash
swiftc -emit-sil yourfile.swift | grep -A 10 sil_witness_table
```

`sil_witness_table` 블록 안에 `method #Producer.produce: ...` 와 `associated_type Output: Int` 형태로 value witness와 type witness가 그대로 찍힙니다. 용어가 컴파일러 출력에 실제로 등장하는 것을 직접 보시는 게 제일 확실할 겁니다.

## 이름이 비슷한 두 테이블

런타임에는 이름이 헷갈리는 테이블이 두 개 있습니다. 검색하면 섞여 나오니 미리 구분해두면 좋습니다.

| 테이블 | 개수 | 담고 있는 것 |
| --- | --- | --- |
| **PWT** (Protocol Witness Table) | (타입, 프로토콜) 쌍마다 하나 | 요구사항 → 구현 매핑 |
| **VWT** (Value Witness Table) | 타입마다 하나 | copy/destroy/move, size, alignment 같은 값 관리 연산 |

"value witness"라는 말이 위에서 본 "메서드 요구사항을 충족하는 선언"이라는 뜻과 런타임의 VWT 양쪽에서 쓰이는 바람에 헷갈리기 쉽습니다. 문맥을 보고 구분하시는 게 좋습니다.

# 연관 타입 (associated type)

공식문서

> An _associated type_ gives a placeholder name to a type that's used as part of the protocol

연관 타입은 프로토콜의 일부분으로 사용되는 타입에 임시 이름(placeholder name)을 제공합니다.

```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    subscript(i: Int) -> Item { get }
}
```

프로토콜을 정의할 때 `Item` 처럼 임시 이름만 지어두고, 나중에 이 프로토콜을 채택하는 실제 구조체나 클래스에서 그 타입을 지정합니다. 즉, **타입 지정을 미룰 수 있게** 해주는 문법입니다.

실무에서 쓰는 예시를 하나 보겠습니다. Input-Output 패턴의 ViewModel 프로토콜입니다.

```swift
protocol InputOutputViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
```

- 어떤 ViewModel이 채택하느냐에 따라 `Input`과 `Output`이 각각 다른 타입으로 정해집니다.

여기서 미리 알아두셔야 할 것이 하나 있습니다. **연관 타입이 있는 프로토콜은 앞으로 계속 문제의 중심에 섭니다.** 이 글 맨 위에서 봤던 `insert` 의문도 결국 여기서 출발합니다.

# 추론 (Inference)

프로토콜을 공부하다 보면 "추론한다"라는 말이 자주 나옵니다. 그런데 **무엇을** 추론한다는 걸까요? 주로 그 목적어는 연관 타입입니다.

컴파일러는 witness의 시그니처에서 **역산해서** 연관 타입을 결정합니다.

```swift
struct IntStack: Container {
    // typealias Item = Int  ← 안 써도 됨
    private var storage: [Int] = []
    mutating func append(_ item: Int) { storage.append(item) }
    subscript(i: Int) -> Int { storage[i] }
}
```

- `append(_ item: Int)` 라는 함수 시그니처에서 `Item`이 `Int`임을 **추론**합니다.
- 만약 `Item`을 가리키는 타입이 서로 일관되지 않으면 "does not conform" 에러가 날 수 있습니다.

`Sequence`나 `Collection`을 채택할 때 `makeIterator()` 하나만 구현해도 `Element`, `Iterator`, `SubSequence`까지 줄줄이 정해지는 것이 이 추론의 대표적인 사례입니다.

참고로 추론은 연관 타입에만 있는 것은 아닙니다.

| 대상 | 언제 결정되나 |
| --- | --- |
| 연관 타입 | 채택한 타입의 구현부(witness) 시그니처에서 역산 |
| 제네릭 파라미터 `<T: P>` | 호출부에서 넘긴 인자 타입으로 결정 |
| `some P` 반환 타입 | `return` 문의 구체 타입에서 역산 (호출자에게는 숨김) |

# 제네릭 (Generic)

타입을 호출하는 쪽에서 정할 수 있게 만드는 문법입니다.

```swift
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
```

- `T`가 무엇이 될지 정하는 주체는 **호출부(클라이언트)** 입니다.
- 함수 구현부는 어떤 타입이 들어오든 처리할 수 있게 일반적으로 작성됩니다.

한 가지 알아두실 점은, **Swift의 프로토콜 선언에는 제네릭을 쓸 수 없다**는 것입니다.

```swift
protocol Container<T> { }  // Error
```

프로토콜에서는 제네릭 대신 연관 타입을 씁니다. 왜 이렇게 설계했는지는 다음 글에서 자세히 다뤄보겠습니다.

# 실존 타입 (Existential Type)

> "프로토콜을 타입 그 자체로 사용했을 때"를 말합니다.

공식문서에 따르면 이 이름은 "어떤 프로토콜을 따르는 타입 `T`가 존재한다(there exists a type T such that T conforms to the protocol)"라는 문장에서 유래했습니다. Boxed Protocol Type이라고도 불립니다.

```swift
protocol Shape { ... }
class Triangle: Shape { ... }

let anyTri: any Shape = Triangle()   // 변수 타입
func draw(shape: any Shape)          // 파라미터
func makeShape() -> any Shape        // 리턴 타입
var shapes: [any Shape]              // 배열 원소
```

- 구체적인 타입 정보가 지워지고(type erasure), 런타임에 프로토콜만 따르면 어떤 타입이든 들어올 수 있습니다.
- 그 대가로 **박스(box)** 라는 간접 레벨이 생기고 성능 비용이 발생합니다.

`any` 키워드가 등장한 이유도 여기에 있습니다. 이 비용을 너무 쉽게 열어줬기 때문에, 키워드를 붙여 경각심을 주려는 목적이었다고 이해됩니다.

# 불투명 타입 (Opaque Type)

> 구현부(그리고 컴파일러)는 구체적인 타입을 알지만, 클라이언트에서는 구체적인 타입을 모르게 하는 것입니다.

`some` 키워드로 표현합니다. 익숙한 코드가 하나 있으실 겁니다.

```swift
struct CustomView: View {
    var body: some View { ... }
}
```

제네릭과 정반대라고 생각하시면 좋을거 같습니다.

| | 타입을 정하는 주체 | 타입을 모르는 쪽 |
| --- | --- | --- |
| **Generic** | 호출부(클라이언트) | 함수 구현부 |
| **Opaque Type** | 함수 구현부 | 호출부(클라이언트) |

# 정리

앞으로 계속 나올 단어들을 한 번에 모아두겠습니다.

| 용어 | 한 줄 정의 |
| --- | --- |
| 요구사항 (Requirement) | 프로토콜이 구현하라고 적어둔 목록 |
| witness | 요구사항을 실제로 충족하는 구현부 |
| PWT / VWT | 런타임에 witness를 찾는 테이블 / 값 관리 연산 테이블 |
| 연관 타입 (associated type) | 프로토콜 안에서 타입 지정을 미루는 임시 이름 |
| 추론 (Inference) | witness 시그니처에서 연관 타입을 역산하는 것 |
| Generic | 호출부가 타입을 정함 |
| Existential Type (`any`) | 프로토콜을 타입 자리에 쓴 것. 타입이 지워짐 |
| Opaque Type (`some`) | 구현부가 타입을 정하고 호출부에는 감춤 |

다음 글에서는 **왜 Swift의 프로토콜에는 제네릭을 쓸 수 없고 연관 타입을 쓰는지** 알아보겠습니다.

도움이 되셨기를 바라며 피드백은 언제나 환영입니다.

참고 자료

[Swift 공식문서 - Generics (Associated Types)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics#Associated-Types)

[Swift 공식문서 - Opaque and Boxed Protocol Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes)

[SE-0335 : Introduce existential `any`](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0335-existential-any.md)

[Swift Forums : Why are generics allowed in Swift protocol declarations but not available in scope?](https://forums.swift.org/t/why-are-generics-allowed-in-swift-protocol-declarations-but-not-available-in-scope/80537/7)
