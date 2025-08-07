import Foundation

let global = DispatchQueue.global()
let custom = DispatchQueue(label: "com.private")

print("main started")

for i in 0...5 {
    custom.sync {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended")

RunLoop.main.run()