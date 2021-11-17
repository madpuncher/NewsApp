import WebKit
import UIKit

final class WebViewController: UIViewController {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            preferences.allowsContentJavaScript = true
        }
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addView()
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func setupNavBar() {
        title = "Страница с источника"
    }
    
    private func addView() {
        view.addSubview(webView)
    }
    
    public func loadView(url: URL?) {
        guard let url = url else { return }
        
        webView.load(URLRequest(url: url))
    }
}
