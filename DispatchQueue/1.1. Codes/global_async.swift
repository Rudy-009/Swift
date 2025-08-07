import Foundation

print("main started ⭐️")

for i in 0...5 {
    DispatchQueue.global().async {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

RunLoop.main.run()