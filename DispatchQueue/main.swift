import Foundation

print("Task0")

DispatchQueue.main.async {
    sleep(1)
    print("Task1")
    exit(0)
}

print("Task2")

RunLoop.main.run()

