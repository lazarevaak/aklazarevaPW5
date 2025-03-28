import Foundation
import UIKit

final class ArticleManager {
    
    // MARK: - Singleton
    
    static let shared = ArticleManager()
    
    // MARK: - Private Properties
    
    private let decoder = JSONDecoder()
    private let cache = NSCache<NSURL, UIImage>()
    
    private struct NewsResponse: Decodable {
        let news: [ArticleModel]
    }
    
    // MARK: - Public Methods
    
    func fetchArticles(
        rubric: Int = 4,
        pageIndex: Int = 1,
        completion: @escaping (Result<[ArticleModel], Error>) -> Void
    ) {
        let urlString = "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.success([])) }
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.success([])) }
                return
            }

            do {
                let wrapper = try self.decoder.decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(wrapper.news))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url as NSURL
        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            var image: UIImage?
            if let d = data, let img = UIImage(data: d) {
                self?.cache.setObject(img, forKey: key)
                image = img
            }
            DispatchQueue.main.async { completion(image) }
        }
        .resume()
    }
}
