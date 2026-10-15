import Darwin

// 1. Array 변수는 힙 버퍼의 주소 8바이트만 들고 있다
var a = [1, 2, 3, 4]
print(MemoryLayout.size(ofValue: a)) // 8
print(a.count, a.capacity)           // 4 4

// 2. 헤더는 32바이트 (메타데이터 8 + RC 8 + count 8 + capacity 8)
var h: [Int] = [1, 2, 3]
h.withUnsafeBufferPointer { buf in
    let base = UInt(bitPattern: buf.baseAddress!)
    let obj = UInt(bitPattern: unsafeBitCast(h, to: UnsafeRawPointer.self))
    print("element offset:", base - obj) // 32
}

// 3. 빈 배열은 힙 할당 없이 전역 빈 저장소를 공유한다
let e1: [Int] = []
let e2: [String] = []
print(unsafeBitCast(e1, to: UnsafeRawPointer.self)
   == unsafeBitCast(e2, to: UnsafeRawPointer.self)) // true

// 4. capacity가 커지는 순간만 출력
// Buffer는 늘어나는 것이 아니라, 더 큰 새 버퍼를 통째로 할당하고 옮긴다.
var b: [Int] = []
var capacity = b.capacity

for i in 1...50 {
    b.append(i)
    if capacity != b.capacity {
        print(b.count, b.capacity)
        capacity = b.capacity
    }
}
// 1 2 / 3 4 / 5 8 / 9 16 / 17 36 / 37 76

// 5. 16 다음이 32가 아니라 36인 이유 — 할당자가 올림한다
for req in [288, 320, 608, 640] {
    print(req, "->", malloc_good_size(req))
}
// 288 -> 320  (헤더 32 + 32 * 8 = 288 요청 → 320 확보 → (320-32)/8 = 36)
