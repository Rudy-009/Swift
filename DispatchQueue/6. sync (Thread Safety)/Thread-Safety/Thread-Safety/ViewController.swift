//
//  ViewController.swift
//  Thread-Safety
//
//  Created by 이승준 on 8/20/25.
//

import UIKit

class ViewController: UIViewController {

    let bankAccountActor = BankAccountActor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        test()
        safeTest()
        Task {
            await actorTest()
            print("actor: \(await bankAccountActor.balance)")
        }
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
        print("unsafe: \(num)")
    }
    
    func safeTest() {
        let bankAccountClass = BankAccountClass()
        for _ in 0..<100 {
            DispatchQueue.global().async {
                bankAccountClass.increment()
            }
            DispatchQueue.global().async {
                bankAccountClass.decrement()
            }
        }
        usleep(100_000)
        print("class: \(bankAccountClass.getValue())")
    }
    
    func actorTest() async {
        for _ in 0..<100 {
            await bankAccountActor.deposit()
            await bankAccountActor.withdraw()
        }
    }

}

class BankAccountClass {
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

actor BankAccountActor {
    
    var balance = 10000
    
    func deposit() {
        balance += 1
    }
    
    func withdraw() {
        balance -= 1
    }
    
}
