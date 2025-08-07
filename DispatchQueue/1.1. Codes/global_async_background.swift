import Foundation

print("main started ⭐️")

for i in 0...100 {
    DispatchQueue.global(qos: .background).async {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

RunLoop.main.run()