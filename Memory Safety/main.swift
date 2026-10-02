var stepSize = 1
func increment(_ number: inout Int) {
    number += stepSize   // stepSize 읽기(instantaneous)가
}                        // number 쓰기(long-term)와 겹침
// increment(&stepSize)     // Error: 둘이 같은 메모리라서 충돌

func p(_ number: inout Int) {
    print(stepSize) // 읽기 작업
}

// p(&stepSize) // Error : 

func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)  // OK
//balance(&playerOneScore, &playerOneScore)
// Error: Conflicting accesses to playerOneScore.


struct Player {
    var name: String
    var health: Int
    var energy: Int


    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

var rudy = Player(name: "Rudy", health: 10, energy: 20)
rudy.restoreHealth()
