import Foundation

print("start")

let global = DispatchQueue.global()

let item1 = DispatchWorkItem() {
    print("item1 \(Thread.current)")
}

let item2 = DispatchWorkItem() {
    print("item2 \(Thread.current)")
}

global.async(execute: item1)

item1.notify(queue: global, execute: item2)

print("end")