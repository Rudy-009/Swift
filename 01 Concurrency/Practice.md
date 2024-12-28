# Task 연습 문제

## 시나리오
당신은 온라인 서점의 iOS 앱을 개발하고 있습니다. 사용자가 책을 검색하면 다음과 같은 비동기 작업들이 필요합니다:
- 책 정보 가져오기
- 책 표지 이미지 다운로드
- 사용자 리뷰 가져오기
- 관련 도서 추천 목록 가져오기

## 요구사항
- 위의 모든 작업은 비동기로 처리되어야 합니다
- 책 정보는 필수이며, 다른 정보들은 선택적으로 로드되어도 됩니다
- 모든 작업의 타임아웃은 5초입니다
- 에러 처리가 포함되어야 합니다
- 작업 진행 상황을 사용자에게 표시해야 합니다
- 다음의 더미 함수들을 사용하여 문제를 해결하세요:

```swift
struct Book: Sendable {
    let id: Int
    let title: String
    let author: String
    let price: Double
}

func fetchBookInfo(id: Int) async throws -> Book {
    // 서버에서 책 정보를 가져오는 비동기 작업
    fatalError("구현 필요")
}

func fetchBookCover(id: Int) async throws -> Data {
    // 책 표지 이미지를 다운로드하는 비동기 작업
    fatalError("구현 필요")
}

func fetchUserReviews(bookId: Int) async throws -> [String] {
    // 사용자 리뷰를 가져오는 비동기 작업
    fatalError("구현 필요")
}

func fetchRecommendations(for book: Book) async throws -> [Book] {
    // 추천 도서 목록을 가져오는 비동기 작업
    fatalError("구현 필요")
}
```