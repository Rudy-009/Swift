import Foundation

let closure = {
    print("Closure Executed 1")
}

closure()

func doSomething() -> () -> () {
    return {
        print("Closure Executed 2")
    }
}

doSomething()()

({ () -> () in
    print("Closure Executed 3")
})()

let label: () = { (name: String) -> () in
   print("Closure Executed 4 \(name)")
}("label")

//func outerFunction(closure: () -> ()) -> () -> (){
//    let closed: () -> () = closure
//    
//    print("\(#function) start")
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        closure()
//    }
//    print("\(#function) end")
//    
//    func inner() {
//        closure()
//    }
//    return inner
//}

func someFuncition() {
    var num: Int = 0
    print("num check #1 = \(num)")
    
    let closure = {
        print("num check #3 = \(num)")
    }
    
    num = 20
    print("num check #2 = \(num)")
    closure()
}

someFuncition()
