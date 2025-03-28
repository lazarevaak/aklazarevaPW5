import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - Properties
    
    private let webView = WKWebView()
    private let url: URL

    // MARK: - Init
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article"
        view.backgroundColor = .systemBackground
        setupWebView()
        loadURL()
    }

    // MARK: - Setup
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.pinToEdges(of: view)
    }

    // MARK: - Load
    
    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
