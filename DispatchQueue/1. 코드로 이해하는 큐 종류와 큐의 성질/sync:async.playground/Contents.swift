import Foundation

// let times: [UInt32] = [UInt32(Int.random(in: 1...4), 0, UInt32(Int.random(in: 1...4)), UInt32(Int.random(in: 1...4))]

func task1() {
    print("🍎 시작")
    sleep(times[0])
    print("🍎 완료 \(times[0])초")
}

func task2() {
    print("⭐️ 시작")
    sleep(times[1])
    print("⭐️ 완료 \(times[1])초")
}

func task3() {
    print("☘️ 시작")
    sleep(times[2])
    print("☘️ 완료 \(times[2])초")
}

func task4() {
    print("🌐 시작")
    sleep(times[3])
    print("🌐 완료 \(times[3])초")
}

let times: [UInt32] = [2, 1, 2, 3]

//func task1() {
//    print("🍎 시작 \(Thread().description)")
//    sleep(times[0])
//    print("🍎 완료 \(times[0])초")
//}
//
//func task2() {
//    print("⭐️ 시작 \(Thread().description)")
//    sleep(times[1])
//    print("⭐️ 완료 \(times[1])초")
//}
//
//func task3() {
//    print("☘️ 시작 \(Thread().description)")
//    sleep(times[2])
//    print("☘️ 완료 \(times[2])초")
//}
//
//func task4() {
//    print("🌐 시작 \(Thread().description)")
//    sleep(times[3])
//    print("🌐 완료 \(times[3])초")
//}

let queue = DispatchQueue(label: "com.example.concurrentQueue")
// let queue = DispatchQueue.main
// let queue = DispatchQueue.global()

print("main started")

//task1()
//task2()
//task3()
//task4()

queue.sync { task1() }
queue.sync { task2() }
queue.sync { task3() }
queue.sync { task4() }

//queue.async { task1() }
//queue.async { task2() }
//queue.async { task3() }
//queue.async { task4() }

print("main ended")

