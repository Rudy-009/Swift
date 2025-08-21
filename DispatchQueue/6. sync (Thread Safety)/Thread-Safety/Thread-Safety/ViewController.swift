//
//  ViewController.swift
//  Thread-Safety
//
//  Created by 이승준 on 8/20/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
        safeTest()
    }
    
    func test() {
        var num = 10000

        for _ in 0..<100 {
            DispatchQueue.global().async {
                num += 1
            }
            DispatchQueue.global().async {
                num -= 1
            }
        }
        sleep(1)
        print(num)
    }
    
    func safeTest() {
        let counter = SafeCounter()
        for _ in 0..<100 {
            DispatchQueue.global().async {
                counter.increment()
            }
            DispatchQueue.global().async {
                counter.decrement()
            }
        }
        usleep(1000_000)
        print(counter.getValue())
    }

}

class SafeCounter {
    private var value: Int = 10000
    private let queue = DispatchQueue(label: "safe.counter.queue")

    func increment() {
        queue.sync {
            self.value += 1
        }
    }

    func decrement() {
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
