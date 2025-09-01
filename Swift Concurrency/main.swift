import Foundation

func add() async {
    print("async function1 \(Thread.current)")

    try? await Task.sleep(nanoseconds: 2_000_000_000)

    print("async function2 \(Thread.current)")

    await MainActor.run {
        // print("async function3 \(Thread.current)")
    }
    exit(0)
}

Task {
    await add()
}

RunLoop.main.run()
