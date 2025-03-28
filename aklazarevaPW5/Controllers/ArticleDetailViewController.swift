import UIKit
import WebKit

final class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let webView = WKWebView()
    private let url: URL

    // MARK: - Initialization
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Статья"
        view.backgroundColor = .systemBackground
        setupWebView()
        loadURL()
    }

    // MARK: - Setup
    
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Load
    
    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
