import Foundation

let serialQueue = DispatchQueue(label: "com.example.serial")

serialQueue.async { // block1
    print("block1 started")
    serialQueue.sync { // block2
        print("block2")
    }
    print("block1 finished")
}