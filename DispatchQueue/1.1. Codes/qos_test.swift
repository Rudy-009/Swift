import Foundation

func testQoSPerformance(qos: DispatchQoS.QoSClass, label: String) {
    let group = DispatchGroup()
    var threadSet = Set<String>()
    let lock = NSLock()
    let taskCount = 1000

    print("\n▶️ [\(label)] 테스트 시작")

    let startTime = CFAbsoluteTimeGetCurrent()

    for _ in 0..<taskCount {
        group.enter()
        DispatchQueue.global(qos: qos).async {
            // 각 작업마다 Thread 정보를 수집
            let threadDesc = Thread.current.description
            lock.lock()
            threadSet.insert(threadDesc)
            lock.unlock()
            
            // CPU 연산 시간 소요
            let _ = (0...10_000).reduce(0, +)

            group.leave()
        }
    }

    group.wait()
    let endTime = CFAbsoluteTimeGetCurrent()
    let duration = endTime - startTime

    print("✅ [\(label)] 완료")
    print("    ⏱ 총 소요 시간: \(String(format: "%.3f", duration))초")
    print("    🧵 쓰레드 수: \(threadSet.count)")
}

// 각 QoS 테스트 실행
testQoSPerformance(qos: .userInteractive, label: "userInteractive")
testQoSPerformance(qos: .userInitiated, label: "userInitiated")
testQoSPerformance(qos: .default, label: "default")
testQoSPerformance(qos: .utility, label: "utility")
testQoSPerformance(qos: .background, label: "background")

// RunLoop 유지 (macOS에서는 필요 없음, iOS Playground에서는 필요할 수 있음)
RunLoop.main.run()