import Foundation

func getTitleOptional(_ isValid: Bool) -> String? {
    if isValid {
        return "optional title"
    } else {
        return nil
    }
}

func getTitleResult(_ isValid: Bool) -> Result<String, Error> {
    if isValid {
        return .success("result title")
    } else {
        return .failure(URLError(.badURL))
    }
}

func getTitleThrows(_ isValid: Bool) throws -> String {
    if isValid {
        return "result title"
    } else {
        throw URLError(.badURL)
    }
}

print(getTitleOptional(false) ?? "no title")

let result = getTitleResult(false)
switch result {
    case .success(let title) :
        print(title)
    case .failure(let error) :
        print(error.localizedDescription)
}

do {
    let title1 = try getTitleThrows(true) // error 가 아니면 동작한다.
    print("title1: ", title1) // result title

    let title2 = try? getTitleThrows(false) // error 이더라도 catch가 아닌 nil을 반환하게 한다.
    print("title2: ", title2 ?? "throwed title") // throwed error

    let title3 = try getTitleThrows(false) // error 가 발생하면 catch 안의 코드가 실행된다.
    // error가 발생한 이후의 코드는 실행되지 않는다.
    print("title3: ", title3)

    let title4 = try getTitleThrows(false)
    print("title4: ", title3)
} catch let error {
    print("error: ", error.localizedDescription)
}
