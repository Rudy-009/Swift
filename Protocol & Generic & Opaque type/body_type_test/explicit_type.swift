import SwiftUI

// ─────────────────────────────────────────────
// 실험: some View 대신 구체 타입을 직접 적을 수 있을까?
// ─────────────────────────────────────────────

// A. modifier가 없는 View → 적을 수 있다 (컴파일 성공)
struct ExplicitSimple: View {
    var body: Text {
        Text("Hello")
    }
}

// B. 중첩된 타입도 적을 수 있다 (컴파일 성공)
struct ExplicitStack: View {
    var body: VStack<TupleView<(Image, Text)>> {
        VStack {
            Image(systemName: "globe")
            Text("Hello, world!")
        }
    }
}

// C. modifier가 하나라도 붙으면? → 컴파일 에러
//
// struct ExplicitModified: View {
//     var body: ModifiedContent<VStack<TupleView<(Image, Text)>>, _PaddingLayout> {
//         VStack {
//             Image(systemName: "globe")
//             Text("Hello, world!")
//         }
//         .padding()
//     }
// }
//
// error: cannot convert return expression of type 'some View'
//        to return type 'ModifiedContent<VStack<TupleView<(Image, Text)>>, _PaddingLayout>'
//
// 이유: padding() 자체의 반환 타입이 `some View` 이다.
//      런타임에는 ModifiedContent<...> 이지만, 정적으로는 이름을 부를 수 없다.

@MainActor
func run() {
    print("A. var body: Text                          →", type(of: ExplicitSimple().body))
    print("B. var body: VStack<TupleView<(Image,Text)>> →", type(of: ExplicitStack().body))
    print("   ExplicitSimple.Body                      →", ExplicitSimple.Body.self)
}
MainActor.assumeIsolated { run() }
