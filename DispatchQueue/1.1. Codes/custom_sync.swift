import Foundation

print("main started")

for i in 0...5 {
    DispatchQueue(label: "com.private").sync {
        print("No.\(i), Thread: \(Thread.current)")
    }
}

print("main ended")