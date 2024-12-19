import UIKit
import WebKit

// MARK: - WebViewController
class WebViewController: UIViewController {
    var url: URL?
    private let webView = WKWebView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupWebView()
        setupShareButton()
        loadURL()
    }

    // MARK: - Setup WebView
    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Setup Share Button
    private func setupShareButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareContent))
        navigationItem.rightBarButtonItem = shareButton
    }

    // MARK: - Share Content
    @objc private func shareContent() {
        guard let fileURL = url else { return }
        
        // Создаем ActivityViewController для шаринга
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // Настройка для iPad (чтобы не было падений из-за popover)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        // Показать меню «Поделиться»
        present(activityViewController, animated: true)
    }
    
    // MARK: - URL Loading
    private func loadURL() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
