import Foundation

let global = DispatchQueue.global()

print("main started ⭐️")

for i in 0...5 {
    global.async {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

RunLoop.main.run()