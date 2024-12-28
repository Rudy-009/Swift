import Foundation
struct Book: Sendable {
    let id: Int
    let title: String
    let author: String
    let price: Double
}

enum BookServiceError: Error {
    case serverError
    case timeoutError
    case cancelled
}

func fetchBookInfo(id: Int) async throws -> Book {
    try Task.checkCancellation()
    
    try await Task.sleep(nanoseconds: UInt64(Double.random(in: 0.5...2) * 1_000_000_000))
    
    if Double.random(in: 0...1) < 0.2 {
        throw BookServiceError.serverError
    }
    
    return Book(id: id, 
                title: "샘플 도서 \(id)", 
                author: "작가 \(id)", 
                price: Double.random(in: 10000...30000))
}

func fetchBookCover(id: Int) async throws -> Data {
    try Task.checkCancellation()
    
    try await Task.sleep(nanoseconds: UInt64(Double.random(in: 0.5...2) * 1_000_000_000))
    
    if Double.random(in: 0...1) < 0.2 {
        throw BookServiceError.serverError
    }
    
    // 실제 이미지 데이터를 시뮬레이션
    return "Book Cover Data".data(using: .utf8) ?? Data()
}

func fetchUserReviews(bookId: Int) async throws -> [String] {
    try Task.checkCancellation()
    
    try await Task.sleep(nanoseconds: UInt64(Double.random(in: 0.5...2) * 1_000_000_000))
    
    if Double.random(in: 0...1) < 0.2 {
        throw BookServiceError.serverError
    }
    
    return [
        "정말 좋은 책이에요! 추천합니다.",
        "내용이 매우 흥미진진해요.",
        "두번째 읽어도 재미있네요.",
        "작가의 시선이 독특해요."
    ]
}

func fetchRecommendations(for book: Book) async throws -> [Book] {
    try Task.checkCancellation()
    
    try await Task.sleep(nanoseconds: UInt64(Double.random(in: 0.5...2) * 1_000_000_000))
    
    if Double.random(in: 0...1) < 0.2 {
        throw BookServiceError.serverError
    }
    
    return [
        Book(id: book.id + 1, title: "추천도서 1", author: "추천작가 1", price: 15000),
        Book(id: book.id + 2, title: "추천도서 2", author: "추천작가 2", price: 18000),
        Book(id: book.id + 3, title: "추천도서 3", author: "추천작가 3", price: 22000)
    ]
}

func fetchBookDetails(id: Int) async throws -> (Book, Data, [String], [Book]) {
    try await withTimeout(seconds: 5) {
        async let book = fetchBookInfo(id: id)
        async let cover = fetchBookCover(id: id)
        async let reviews = fetchUserReviews(bookId: id)
        let bookInfo = try await book
        let recommendations = try await fetchRecommendations(for: bookInfo)
        
        return try await (book, cover, reviews, recommendations)
    }
}

func withTimeout<T>(seconds: Double, operation: @escaping () async throws -> T) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        // 실제 작업 Task 추가
        group.addTask {
            try await operation()
        }
        
        // 타임아웃 Task 추가
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw BookServiceError.timeoutError
        }
        
        do {
            // 먼저 완료되는 작업의 결과를 가져옴
            if let result = try await group.next() {
                group.cancelAll()
                return result
            } else {
                throw BookServiceError.timeoutError
            }
        } catch {
            // 에러 발생 시 모든 작업 취소
            group.cancelAll()
            throw error
        }
    }
}
