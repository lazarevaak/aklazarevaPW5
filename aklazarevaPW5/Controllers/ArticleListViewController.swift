import UIKit

final class ArticleListViewController: UIViewController {
    private let tableView = UITableView()
    private var articles: [ArticleModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новости"
        view.backgroundColor = .systemBackground
        setupTableView()
        loadArticles()
    }

    // MARK: - Setup

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseID)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.rowHeight  = 80
    }

    // MARK: - Data

    private func loadArticles() {
        ArticleManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let list):
                self?.articles = list
                self?.tableView.reloadData()
            case .failure(let error):
                // Здесь можно показать алерт с error.localizedDescription
                print("Ошибка загрузки статей:", error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ArticleListViewController: UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    func tableView(
        _ tv: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(
            withIdentifier: ArticleCell.reuseID,
            for: indexPath
        )
        if let articleCell = cell as? ArticleCell {
            articleCell.configure(with: articles[indexPath.row])
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ArticleListViewController: UITableViewDelegate {
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Разворачиваем optional URL
        let model = articles[indexPath.row]
        guard let url = model.articleURL else {
            // Можно показать сообщение об ошибке или просто вернуть
            print("Invalid article URL for newsId:", model.newsId)
            tv.deselectRow(at: indexPath, animated: true)
            return
        }

        let detailVC = ArticleDetailViewController(url: url)
        navigationController?.pushViewController(detailVC, animated: true)
        tv.deselectRow(at: indexPath, animated: true)
    }
}
