import Foundation

// MARK: - NewsPage
struct NewsPage: Decodable {
    var news: [ArticleModel]?
    var requestId: String?

    // MARK: - Methods
    mutating func passTheRequestId() {
        guard let requestId = requestId else { return }
        news = news?.map { article in
            var a = article
            a.requestId = requestId
            return a
        }
    }
}
