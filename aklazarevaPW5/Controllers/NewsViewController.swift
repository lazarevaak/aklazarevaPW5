import UIKit

final class NewsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Data
    
    private var articles: [ArticleModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        setupTableView()
        loadArticles()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pinToEdges(of: view)
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(loadArticles), for: .valueChanged)
    }
    
    // MARK: - Data Loading
    
    @objc private func loadArticles() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        ArticleManager.shared.fetchArticles { [weak self] (result: Result<[ArticleModel], Error>) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            
            switch result {
            case .success(let list):
                self.articles = list
                self.tableView.reloadData()
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    // MARK: - Error Handling
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка загрузки",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
        cell.configure(with: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = articles[indexPath.row].articleURL {
            let detailVC = WebViewController(url: url)
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tv.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tv: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") { [weak self] _, _, done in
            if let url = self?.articles[indexPath.row].articleURL {
                let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self?.present(av, animated: true)
            }
            done(true)
        }
        share.backgroundColor = UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [share])
    }
}
