import Foundation

class ArticleManager {
    private let decoder = JSONDecoder()
    private var newsPage = NewsPage()
    var articles: [ArticleModel] = []

    // MARK: - Fetch Articles
    func fetchArticles(rubric: Int = 4, pageIndex: Int = 1, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)") else {
            completion()
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            guard let data = data, let self = self else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            if var newsPage = try? self.decoder.decode(NewsPage.self, from: data) {
                newsPage.passTheRequestId()
                self.articles = newsPage.news ?? []
            }

            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}
