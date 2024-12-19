import UIKit

class NewsViewController: UIViewController {
    private let tableView = UITableView()
    private let manager = ArticleManager()
    private var articles: [ArticleModel] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "News"

        setupTableView()
        loadNews()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    // MARK: - Data Loading
    private func loadNews() {
        manager.fetchArticles { [weak self] in
            self?.articles = self?.manager.articles ?? []
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as! ArticleCell
        cell.configure(with: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let webVC = WebViewController()
        webVC.url = article.articleUrl
        navigationController?.pushViewController(webVC, animated: true)
    }

    // MARK: - Swipe Actions
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (_, _, completionHandler) in
            guard let url = self?.articles[indexPath.row].articleUrl else { return }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self?.present(activityVC, animated: true)
            completionHandler(true)
        }
        shareAction.backgroundColor = .systemBlue

        let configuration = UISwipeActionsConfiguration(actions: [shareAction])
        return configuration
    }
}
