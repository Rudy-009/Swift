import SwiftUI

// ══════════════════════════════════════════════════════════
//  실험: some View 자리에 any View를 쓰면 어디서 막히는가?
//
//  아래 블록을 하나씩 주석 해제하면서 컴파일해보세요.
//      swift any_view.swift
//
//  에러가 났다면 에러 메시지를 그대로 읽어보는 게 핵심입니다.
//  "무엇을 할 수 없다"고 말하는지가 답입니다.
// ══════════════════════════════════════════════════════════


// ── 실험 1 ────────────────────────────────────────────────
// Q. associatedtype이 있는 프로토콜을 타입 자리에 쓸 수 있나?
//    (노트 310줄 vs 334줄의 단서를 여기서 판정)

// let v: any View = Text("Hello")


// ── 실험 2 ────────────────────────────────────────────────
// Q. 실험 1이 됐다면, 거기에 modifier를 이어붙일 수 있나?
//    (노트 287줄 "변환이 중첩되지 않는다"를 여기에 대입)

// let v2: any View = Text("Hello")
// let v3 = v2.padding()


// ── 실험 3 ────────────────────────────────────────────────
// Q. body의 타입을 any View로 선언하면 View를 채택할 수 있나?
//    View 프로토콜의 요구사항은 `var body: Self.Body { get }` 이고
//    `associatedtype Body : View` 이다. any View가 그 Body가 될 수 있나?

// struct AnyBodyView: View {
//     var body: any View {
//         Text("Hello")
//     }
// }


// ── 실험 4 ────────────────────────────────────────────────
// Q. AnyView는 어떤가? 이건 SwiftUI가 제공하는 타입이다.
//    실험 3과 무엇이 다른가? AnyView의 정의를 Xcode에서 열어보자.

// struct ErasedView: View {
//     var body: some View {
//         AnyView(Text("Hello").padding())
//     }
// }
//
// @MainActor func run4() {
//     print(type(of: ErasedView().body))
//     // X1에서 찍었던 타입과 비교해보기:
//     //   ModifiedContent<VStack<TupleView<(Image, Text)>>, _PaddingLayout>
//     // 무엇이 사라졌는가?
// }
// MainActor.assumeIsolated { run4() }


// ── 실험 5 ────────────────────────────────────────────────
// Q. 타입이 지워지면 "같은 뷰인지" 판단할 수 있나?
//    노트 266줄(== 연산자)과 221~222줄 표의 "구체 타입의 정체성" 행을 보고
//    아래가 왜 안 되는지 먼저 예상한 뒤에 컴파일해보자.

// let a: any View = Text("Hello")
// let b: any View = Text("Hello")
// print(a == b)


print("주석을 하나씩 해제하며 실행해보세요.")
