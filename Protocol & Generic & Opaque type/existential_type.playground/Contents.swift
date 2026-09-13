protocol Pet: Hashable {
    associatedtype Data
    var id: Int { get }
    func feed(_ data: Data)
}

struct Dog: Pet {
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.id == lhs.id
    }
    var id: Int
    typealias Data = Int
    func feed(_ data: Data) { }
}

func insert<T>(_ model: T) where T : Pet {
    
}

func insert(_ model: any Pet) {
    
}

let someDog: any Pet = Dog(id: 10)

// someDog.feed(10)

func hello(_ pet: any Pet) {
    print("hello")
}

hello(someDog)

protocol Shape {
    func area() -> Double
}

class Circle: Shape {
    func area() -> Double {
        return 5.0
    }
}

let circle: Shape = Circle()
