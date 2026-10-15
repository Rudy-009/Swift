var a: [Int] = []
print(MemoryLayout.size(ofValue: a)) // 8
print(a.count, a.capacity)
// a.reserveCapacity(10)
print(a, a.capacity)

// Buffer는 늘어나는 것이 아니라 더 큰 새 버퍼를 통째로 새로 할당하고 옮긴다.

var capacity = a.capacity

for i in 1...50 {
    a.append(i)
    if capacity != a.capacity {
        print(a.count, a.capacity)
        capacity = a.capacity
    }
}