import Foundation

// MARK: - Dynamic Coding Key

private struct DynamicCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
}

// MARK: - Article Model

struct ArticleModel: Decodable {
    let newsId: Int
    let title: String
    let announce: String
    let img: ImageContainer?
    let requestId: String

    var articleURL: URL? {
        URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)")
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: DynamicCodingKey.self)

        if let v = try? c.decode(Int.self, forKey: DynamicCodingKey(stringValue: "newsId")!) {
            newsId = v
        } else if let v = try? c.decode(Int.self, forKey: DynamicCodingKey(stringValue: "id")!) {
            newsId = v
        } else {
            throw DecodingError.keyNotFound(
                DynamicCodingKey(stringValue: "newsId")!,
                .init(codingPath: decoder.codingPath, debugDescription: "Нет ключа newsId/id")
            )
        }

        if let v = try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "title")!) {
            title = v
        } else {
            title = (try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "header")!)) ?? ""
        }

        if let v = try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "announce")!) {
            announce = v
        } else if let v = try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "description")!) {
            announce = v
        } else {
            announce = (try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "anons")!)) ?? ""
        }

        if let obj = try? c.decode(ImageContainer.self, forKey: DynamicCodingKey(stringValue: "img")!) {
            img = obj
        } else if let urlString = try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "imageUrl")!) {
            img = ImageContainer(url: URL(string: urlString)!)
        } else {
            img = nil
        }

        if let v = try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "requestId")!) {
            requestId = v
        } else {
            requestId = (try? c.decode(String.self, forKey: DynamicCodingKey(stringValue: "request_id")!)) ?? ""
        }
    }
}

// MARK: - Image Container

struct ImageContainer: Decodable {
    let url: URL
}
