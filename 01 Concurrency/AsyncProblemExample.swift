import Foundation

func listPhotos(inGallery: String) -> [String] {
    var result: [String] = []
    
    // 시간이 걸리는 네트워크 작업 시뮬레이션
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        result = ["photo1", "photo2"] // return 대신 변수에 할당
    }
    return result // 빈 배열이 즉시 반환됨
}

func downloadPhoto(named: String) -> String {
    var result = "Empty"
    
    // 시간이 걸리는 다운로드 작업 시뮬레이션
    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
        result = "Downloaded_\(named)" // return 대신 변수에 할당
    }
    return result // 빈 결과가 즉시 반환됨
}

// 실행
print("Start")
let photoNames = listPhotos(inGallery: "Summer Vacation")
print("photoNames: \(photoNames)")

let sortedNames = photoNames.sorted()
print("sortedNames: \(sortedNames)")

// 빈 배열에서 접근하므로 런타임 에러 발생
let name = sortedNames[0] // Index out of range 에러
let photo = downloadPhoto(named: name)
print("Result: \(photo)")
