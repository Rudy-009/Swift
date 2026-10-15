func addr(_ x: [Int]) -> UnsafeRawPointer {
    x.withUnsafeBufferPointer { UnsafeRawPointer($0.baseAddress!) }
}

// 1. 공유 중인 버퍼를 변경하면, 변경한 쪽이 새 버퍼를 복사해 받아간다
var a: [Int] = [1, 2, 3]
print(addr(a))
var b = a
print(addr(b)) // a와 같음 — 할당만으로는 복사하지 않는다
b.removeLast()
print(addr(a)) // 그대로
print(addr(b)) // 달라짐

// 2. 혼자 쓰고 있다면 변경해도 복사하지 않고 제자리에서 바꾼다
// 주의: 리터럴로 만든 배열은 -O에서 정적 메모리에 놓일 수 있어
//      혼자 쓰고 있어도 첫 변경에서 새 버퍼가 잡힌다. append로 채워야 한다.
var c: [Int] = []
for i in 1...3 { c.append(i) }
let before = addr(c)

c.removeLast()
print(before == addr(c)) // true

c[0] = 99
print(before == addr(c)) // true
