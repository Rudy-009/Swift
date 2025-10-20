import Foundation

func parentFunction() async throws {
    /// async 함수 내부에서 다른 async 함수를 호출 ===> 동일한 비동기 컨텍스트에서의 실행 (작업의 일부)
    try await asyncFunction()
    try await asyncFunction()

    /// Task를 사용하여 명시적으로 다른 작업(Task) 생성도 가능 (구조적 동시성은 아님) - 따로 작업을 만듦 (병렬 실행)
    /// 자식(Child) 작업의 생성 방식은 아님
    Task {
        try await anotherParentFunction()
        try await anotherParentFunction()
    }
    
    print("비동기 함수 실행의 종료")
}

Task {
    try? await parentFunction()
}

func asyncFunction() async throws {
    try await Task.sleep(for: .seconds(2))
    print("비동기 작업의 실행")
}


func anotherParentFunction() async throws {
    try await Task.sleep(for: .seconds(2))
    print("다른 부모 작업의 실행")
}

RunLoop.main.run()
