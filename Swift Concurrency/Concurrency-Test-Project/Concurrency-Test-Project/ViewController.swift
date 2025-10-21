//
//  ViewController.swift
//  Concurrency-Test-Project
//
//  Created by 이승준 on 10/20/25.
//

import UIKit

let loop = 50_000_000

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        Task {
//            await nonSuspendingAwait()
//            await runIOBoundTasks(count: 6, delaySeconds: 0.5)
            await runCPUBoundTasksWithYield(count: 6)
//            await runCPUBoundTasksWithoutVariable(count: 6)
//            await await runCPUBoundTasks(count: 6)
           // await runIOBoundTaskswithoutVariable(count: 6, delaySeconds: 0.005)
//            await concurrentIOBoundTaskWithTaskGroup(count: 20, delaySeconds: 0.5)
//            await concurrentCPUBoundTaskWithTaskGroup(count: 20)
        }
        
//        Task.detached {
//            await runCPUBoundTasksDetached(count: 6)
//        }
    }
}

func simpleAsyncCalculation() async {
    _ = 10 * 5
}

func nonSuspendingAwait() async {
    print("  -> Non-Suspending Await Task 시작 (Main Actor)")
    // 이 Task는 @MainActor 컨텍스트(ViewController.viewDidLoad에서 호출)를 상속받습니다.
    // Task 내부 코드는 Main Thread에서 실행됩니다.
    
    let start = Date()
    
    // **핵심:** await가 붙었지만, simpleAsyncCalculation()은 즉시 완료되므로,
    // 이 지점에서 Main Thread가 다른 Task에게 양보(Suspend)되지 않고 실행이 계속됩니다.
    // 즉, await는 '잠재적인' 중단 지점일 뿐, 실제로는 중단이 일어나지 않습니다.
    Task {
        let _ = await simpleAsyncCalculation() // <--- await는 있지만, Suspension은 일어나지 않을 가능성이 매우 높음
    }
    Task {
        let _ = await simpleAsyncCalculation()
    }
    Task {
        let _ = await simpleAsyncCalculation()
    }
    let duration = Date().timeIntervalSince(start)
    print("  -> Task 완료. (실제 중단이 없어 거의 즉시 완료됨) 소요 시간: \(String(format: "%.10f", duration))초.")
}

func CPUBoundTask(i: Int, count: Int) async {
    var result: Double = 0
    let start = Date()
    for i in 0..<loop {
        guard i % loop/5 != 0 else { // CPUBoundTaskWithYeild와의 연산량을 맞추기 위함
            continue
        }
        result += sin(Double(i)) * cos(Double(i)) * sqrt(Double(i % 1000))
    }
    let duration = Date().timeIntervalSince(start)
    print("  [\(i)/\(count)] 완료. 소요 시간: \(String(format: "%.10f", duration))초.")
}

func runCPUBoundTasks(count: Int) async {
    print("  -> Concurrent CPU Bound Task 시작 (총 \(count)개)")
    let start = Date()
    
    let task1 = Task {
        return await CPUBoundTask(i: 1, count: count)
    }
    let task2 = Task {
        return await CPUBoundTask(i: 2, count: count)
    }
    let task3 = Task {
        return await CPUBoundTask(i: 3, count: count)
    }
    let task4 = Task {
        return await CPUBoundTask(i: 4, count: count)
    }
    let task5 = Task {
        return await CPUBoundTask(i: 5, count: count)
    }
    let task6 = Task {
        return await CPUBoundTask(i: 6, count: count)
    }
    
    _ = await task2.value
    _ = await task1.value
    _ = await task4.value
    _ = await task3.value
    _ = await task5.value
    _ = await task6.value
    
    let totalDuration = Date().timeIntervalSince(start)
    print("  -> Task 완료. 총 소요 시간: \(String(format: "%.10f", totalDuration))초.")
}

func runCPUBoundTasksWithoutVariable(count: Int) async {
    Task {
        return await CPUBoundTask(i: 1, count: count)
    }
    Task {
        return await CPUBoundTask(i: 2, count: count)
    }
    Task {
        return await CPUBoundTask(i: 3, count: count)
    }
    Task {
        return await CPUBoundTask(i: 4, count: count)
    }
    Task {
        return await CPUBoundTask(i: 5, count: count)
    }
    Task {
        return await CPUBoundTask(i: 6, count: count)
    }
}

func runCPUBoundTasksDetached(count: Int) async {
    print("  -> Concurrent CPU Bound Task 시작 (총 \(count)개)")
    let start = Date()
    
    let task1 = Task.detached {
        return await CPUBoundTask(i: 1, count: count)
    }
    let task2 = Task.detached {
        return await CPUBoundTask(i: 2, count: count)
    }
    let task3 = Task.detached {
        return await CPUBoundTask(i: 3, count: count)
    }
    let task4 = Task.detached {
        return await CPUBoundTask(i: 4, count: count)
    }
    let task5 = Task.detached {
        return await CPUBoundTask(i: 5, count: count)
    }
    let task6 = Task.detached {
        return await CPUBoundTask(i: 6, count: count)
    }
    
    _ = await task2.value
    _ = await task1.value
    _ = await task4.value
    _ = await task3.value
    _ = await task5.value
    _ = await task6.value
    
    let totalDuration = Date().timeIntervalSince(start)
    print("  -> Task 완료. 총 소요 시간: \(String(format: "%.10f", totalDuration))초.")
}

func CPUBoundTaskWithYeild(i: Int, count: Int) async {
    var result: Double = 0
    let start = Date()
    for i in 1..<loop {
        guard i % 10_000_000 != 0 else {
            await Task.yield()
            continue
        }
        result += sin(Double(i)) * cos(Double(i)) * sqrt(Double(i % 1000))
    }
    let duration = Date().timeIntervalSince(start)
    print("  [\(i)/\(count)] 완료. 소요 시간: \(String(format: "%.10f", duration))초.")
}

func runCPUBoundTasksWithYield(count: Int) async {
    print("  -> Concurrent CPU Bound Task 시작 (총 \(count)개)")
    let start = Date()
    
    let task1 = Task {
        return await CPUBoundTaskWithYeild(i: 1, count: count)
    }
    let task2 = Task {
        return await CPUBoundTaskWithYeild(i: 2, count: count)
    }
    let task3 = Task {
        return await CPUBoundTaskWithYeild(i: 3, count: count)
    }
    let task4 = Task {
        return await CPUBoundTaskWithYeild(i: 4, count: count)
    }
    let task5 = Task {
        return await CPUBoundTaskWithYeild(i: 5, count: count)
    }
    let task6 = Task {
        return await CPUBoundTaskWithYeild(i: 6, count: count)
    }
    
    _ = await task2.value
    _ = await task1.value
    _ = await task4.value
    _ = await task3.value
    _ = await task5.value
    _ = await task6.value
    
    let totalDuration = Date().timeIntervalSince(start)
    print("  -> Task 완료. 총 소요 시간: \(String(format: "%.10f", totalDuration))초.")
}

func concurrentCPUBoundTaskWithTaskGroup(count: Int) async {
    print("  -> Concurrent CPU Task Group 시작 (총 \(count)개)")
    let start = Date()
    
    // 자식 Task의 완료를 기다립니다.
    await withDiscardingTaskGroup() { group in // 자식 Task의 반환값은 필요 없으므로 Discarding 사용
        for i in 1...count {
            group.addTask {
                await CPUBoundTask(i: i, count: count)
            }
        }
    }
    
    let totalDuration = Date().timeIntervalSince(start)
    print("  -> Task Group 완료. 그룹 내 총 소요 시간: \(String(format: "%.10f", totalDuration))초.")
    // 총 소요 시간은 가장 오래 걸린 Task의 시간(delay seconds)에 근접해야 한다.
}

// MARK: I/O Bound
func runIOBoundTasks(count: Int, delaySeconds: Double) async {
    print("  -> Concurrent IO Bound Task 시작 (총 \(count)개)")
    let start = Date()
    
    let task1 = Task {
        return await IOBoundTask(i: 1, count: count, delaySeconds: delaySeconds)
    }
    let task2 = Task {
        return await IOBoundTask(i: 2, count: count, delaySeconds: delaySeconds)
    }
    let task3 = Task {
        return await IOBoundTask(i: 3, count: count, delaySeconds: delaySeconds)
    }
    let task4 = Task {
        return await IOBoundTask(i: 4, count: count, delaySeconds: delaySeconds)
    }
    let task5 = Task {
        return await IOBoundTask(i: 5, count: count, delaySeconds: delaySeconds)
    }
    let task6 = Task {
        return await IOBoundTask(i: 6, count: count, delaySeconds: delaySeconds)
    }
    
    _ = await task1.value
    _ = await task2.value
    _ = await task3.value
    _ = await task4.value
    _ = await task5.value
    _ = await task6.value
    
    let totalDuration = Date().timeIntervalSince(start)
    print("  -> Task 완료. 총 소요 시간: \(String(format: "%.10f", totalDuration))초.")
}

func runIOBoundTaskswithoutVariable(count: Int, delaySeconds: Double) async {
    Task {
        return await IOBoundTask(i: 1, count: count, delaySeconds: delaySeconds)
    }
    Task {
        return await IOBoundTask(i: 2, count: count, delaySeconds: delaySeconds)
    }
    Task {
        return await IOBoundTask(i: 3, count: count, delaySeconds: delaySeconds)
    }
    Task {
        return await IOBoundTask(i: 4, count: count, delaySeconds: delaySeconds)
    }
    Task {
        return await IOBoundTask(i: 5, count: count, delaySeconds: delaySeconds)
    }
    Task {
        return await IOBoundTask(i: 6, count: count, delaySeconds: delaySeconds)
    }
}

func IOBoundTask(i: Int, count: Int, delaySeconds: Double) async {
    // Task.sleep은 Non-Blocking 방식으로 스레드를 양보(suspend)한다.
    // 이 시점에서 다른 Task가 이 스레드를 점유할 수 있게 된다.
    let start = Date()
    try? await Task.sleep(for: .seconds(delaySeconds))
    let duration = Date().timeIntervalSince(start)
    print("  [\(i)/\(count)] 완료. 소요 시간: \(String(format: "%.10f", duration))초.")
}

func concurrentIOBoundTask(count: Int, delaySeconds: Double) async {
    for i in 1...count {
        Task(name: "No. \(i) Task") {
            await IOBoundTask(i: i, count: count, delaySeconds: delaySeconds)
        }
    }
}

func concurrentIOBoundTaskWithTaskGroup(count: Int, delaySeconds: Double) async {
    print("  -> Concurrent I/O Task Group 시작 (총 \(count)개)")
    let start = Date()
    
    // 자식 Task의 완료를 기다립니다.
    await withDiscardingTaskGroup() { group in // 자식 Task의 반환값은 필요 없으므로 Discarding 사용
        for i in 1...count {
            group.addTask {
                await IOBoundTask(i: i, count: count, delaySeconds: delaySeconds)
            }
        }
    }
    
    let totalDuration = Date().timeIntervalSince(start)
    print("  -> Task Group 완료. 그룹 내 총 소요 시간: \(String(format: "%.10f", totalDuration))초.")
    // 총 소요 시간은 가장 오래 걸린 Task의 시간(delay seconds)에 근접해야 한다.
}
