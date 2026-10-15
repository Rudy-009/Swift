let capacity = 8
// for key in ["apple", "apply", "banana", "cherry"] {
    // let h = key.hashValue
    // print(key, h, h & (capacity - 1))
// }

var dict: [Int: Int] = [:]
var last = dict.capacity
for i in 0..<100 {
    dict[i] = i
    if dict.capacity != last {
        print("count \(dict.count): capacity \(last) → \(dict.capacity)  \(dict.capacity * 4 / 3)")
        last = dict.capacity
    }
}