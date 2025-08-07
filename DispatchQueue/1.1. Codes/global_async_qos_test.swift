import Foundation

// 시간을 재기위해 만든 함수
public func timeCheck(_ block: () -> ()) -> TimeInterval {
    let start = Date()
    block()
    return Date().timeIntervalSince(start)
}

timeCheck{
    for i in 0...1000 {
        DispatchQueue.global().async {
            print("No.\(i), Thread: \(Thread.current)")
        }
    }
}

RunLoop.main.run()

// |  .userInteractive   |   43  | 
// | .userInitiated | 17 | 
// | .default | 14 | 
// | .utility | 23 | 
// | .background | 3 |