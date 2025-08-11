import Foundation

let group1 = DispatchGroup()
let global = DispatchQueue.global()

//global.async(group: group1) {
//    sleep(1)
//    print("Task1 Completed : \(Thread.current)")
//}
//
//global.async(group: group1) {
//    sleep(2)
//    print("Task2 Completed : \(Thread.current)")
//}
//
//global.async(group: group1) {
//    sleep(1)
//    print("Task3 Completed : \(Thread.current)")
//}

//group1.notify(queue: DispatchQueue.main) {
//    print("All Tasks Completed : \(Thread.current)")
//}

//global.async {
//    print("wait started : \(Thread.current)")
//    group1.wait() // Waits synchronously for the previously submitted work to finish.
//    // 현재 쓰레드를 block
//    print("wait ended : \(Thread.current)")
//}

//
//switch group1.wait(timeout: .now() + 2) {
//case .success:
//    print("suceeded")
//case .timedOut:
//    print("timeout")
//}

global.async(group: group1) {
    print("Sync Task A Completed : \(Thread.current)")
    group1.enter()
    global.async {
        sleep(2)
        print("Async Task X Completed : \(Thread.current)")
        group1.leave()
    }
    print("Sync Task B End : \(Thread.current)")
}

group1.notify(queue: .main) {
    print("All Tasks Completed : \(Thread.current)")
}
