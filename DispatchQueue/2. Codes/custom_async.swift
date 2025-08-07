import Foundation

let custom = DispatchQueue(label: "com.private")

print("main started ⭐️")

for i in 0...5 {
    custom.async {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended ⭐️")

RunLoop.main.run()