import Foundation

// MARK: - ArticleModel
struct ArticleModel: Decodable {
    var newsId: Int?
    var title: String?
    var announce: String?
    var img: ImageContainer?
    var requestId: String?

    // MARK: - Computed Properties
    var articleUrl: URL? {
        guard let rid = requestId, let nid = newsId else { return nil }
        return URL(string: "https://news.myseldon.com/ru/news/index/\(nid)?requestId=\(rid)")
    }
}

// MARK: - ImageContainer
struct ImageContainer: Decodable {
    var url: URL?
}
