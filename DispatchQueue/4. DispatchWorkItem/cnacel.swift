import Foundation

print("start")

let global = DispatchQueue.global()

let item1 = DispatchWorkItem() {
    sleep(1)
    print("item1 \(Thread.current)")
}

let item2 = DispatchWorkItem() {
    sleep(1)
    print("item2 \(Thread.current)")
}

item1.cancel()

global.async(execute: item1)
global.async(execute: item2)
usleep(10) // 10 마이크로초, 
// 이 코드가 없으면 item2가 실행상태에 들어가기 전에 아래 코드가 먼저 실행될 수 있다.
item2.cancel()

RunLoop.current.run(until: Date(timeIntervalSinceNow: 3))
print("end")