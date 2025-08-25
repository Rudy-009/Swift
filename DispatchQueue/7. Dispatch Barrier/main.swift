import Foundation

class BarrieredArray<T> {

    private var array = [T]()
    private let queue = DispatchQueue(
        label: "com.main.BarrieredArray",
        attributes: .concurrent
    )

    func append(_ element: T) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    var elements: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
}

let safeArray = BarrieredArray<Int>()

// 여러 스레드에서 동시에 쓰기 작업 실행
for i in 0..<100 {
    DispatchQueue.global().async {
        safeArray.append(i)
    }
    print(safeArray.elements)
}
print(safeArray.elements)

// 2초 후 최종 배열 확인
DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
    print("Final Array Count: \(safeArray.elements.count)")
}

RunLoop.current.run(until: Date(timeIntervalSinceNow: 4))