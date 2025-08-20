import Foundation

var num = 10000

for _ in 0..<100 {
    DispatchQueue.global().async {
        num += 1
    }
    DispatchQueue.global().async {
        num -= 1
    }
}

print(num)

struct SafeCounter {
    private var value: Int = 1000
    private let queue = DispatchQueue(label: "safe.counter.queue")

    mutating func increment() {
        queue.sync {
            self.value += 1
        }
    }

    mutating func decrement() {
        queue.sync {
            self.value -= 1
        }
    }

    func getValue() -> Int {
        queue.sync {
            return self.value
        }
    }
}

var counter = SafeCounter()

for _ in 0..<100 {
    DispatchQueue.global().async {
        counter.increment()
    }
    DispatchQueue.global().async {
        counter.decrement()
    }
}

// 비동기 작업이 끝날 때까지 대기
sleep(1)
print(counter.getValue())