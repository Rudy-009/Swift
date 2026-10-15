var a: [Int] = [1, 2, 3]
print(addr(a))
var b = a
print(addr(b))
b.removeLast()
print(addr(a))
print(addr(b))

// b는 새로운 버퍼를 할당받고 그 자리에서 변경한 값을 쓴다.

func addr(_ x: [Int]) -> UnsafeRawPointer {
    x.withUnsafeBufferPointer { UnsafeRawPointer($0.baseAddress!) }
}