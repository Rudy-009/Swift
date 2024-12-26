
// 1단계: 첫 번째 비동기 함수
func fetchUserData() async throws -> User {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
    return User(id: 1, name: "John")
}

// 2단계: 비동기 함수 호출
func loadUserProfile() async {
    do {
        let user = try await fetchUserData()
        print("User loaded: \(user.name)")
    } catch {
        print("Error loading user: \(error)")
    }
}

// 3단계: 여러 비동기 작업 조합
// let user = try await fetchUserData()
// let posts = try  await fetchUserPosts()
// let friends: [User] = try await fetchUserFriends()
// 위 코드는 user가 실행이 되어야 posts에 값이 할다된다 이를 병렬적으로 실행하고 싶으면 아래 코드처럼 작성할 수 있다.

func loadUserWithDetails() async throws {
    async let user = fetchUserData()
    async let posts = fetchUserPosts()
    async let friends: [User] = fetchUserFriends()

    let results = try await (user, posts, friends)
    print(results.0.info())
    for p in results.1 {
        print(p.info())
    }
    for u in results.2 {
        print(u.info())
    }
}

try await loadUserWithDetails()


struct User {
    let id: Int
    let name: String

    func info() -> String {
        return "id: \(id)\nname: \(name)\n"
    }
}

struct Post {
    let id: Int
    let content: String
    let user: User

    func info() -> String {
        return "id: \(id)\ncontent: \(content)\nuser: \(user.info())"
    }
}

func fetchUserPosts() async throws -> [Post] {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
    return [Post(id: 12, content: "Hello", user: User(id: 1, name: "John"))]
}

func fetchUserFriends() async throws -> [User] {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
    return [User(id: 33, name: "Luke"), User(id: 93, name: "Lance"), User(id: 53, name: "Laura")]
}
