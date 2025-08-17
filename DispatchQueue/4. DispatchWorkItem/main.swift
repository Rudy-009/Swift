import Foundation

print("start")

let global = DispatchQueue.global()

let item = DispatchWorkItem() {
    let alarm = UInt32(Int.random(in: 1...3))
    sleep(alarm)
    print("item \(alarm) \(Thread.current)")
}

let item2 = DispatchWorkItem() {
    print("execute after item \(Thread.current)")
}

global.async(execute: item)

global.async() {
    item.wait()
    print("item wait done \(Thread.current)")
}

item.notify(queue: .main, execute: item2)
item.notify(queue: global, execute: item2)
item.notify(queue: DispatchQueue(label: "private") , execute: item2)

RunLoop.current.run(until: Date(timeIntervalSinceNow: 4))
print("end")
