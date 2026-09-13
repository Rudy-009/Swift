import SwiftUI

// 1. 가장 단순한 View
struct SimpleView: View {
    var body: some View {
        Text("Hello")
    }
}

// 2. 스택으로 감싸고 modifier 하나
struct StackView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
            Text("Hello, world!")
        }
        .padding()
    }
}

// 3. 조건문이 들어간 View
struct ConditionalView: View {
    let flag: Bool
    var body: some View {
        if flag {
            Text("참")
        } else {
            Image(systemName: "star")
        }
    }
}

// 4. 반복문이 들어간 View
struct LoopView: View {
    var body: some View {
        VStack {
            ForEach(0..<3, id: \.self) { i in
                Text("\(i)")
            }
        }
    }
}

// 5. 조금 더 현실적인 View
struct ProfileView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 44, height: 44)
            VStack(alignment: .leading) {
                Text("이승준")
                    .font(.headline)
                Text("iOS Developer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
    }
}

@MainActor
func run() {
    print("1. SimpleView")
    print(type(of: SimpleView().body), terminator: "\n\n")

    print("2. StackView")
    print(type(of: StackView().body), terminator: "\n\n")

    print("3. ConditionalView")
    print(type(of: ConditionalView(flag: true).body), terminator: "\n\n")

    print("4. LoopView")
    print(type(of: LoopView().body), terminator: "\n\n")

    print("5. ProfileView")
    print(type(of: ProfileView().body), terminator: "\n\n")
}

MainActor.assumeIsolated { run() }
