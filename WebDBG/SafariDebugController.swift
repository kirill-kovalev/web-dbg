//
//  SafariDebugController.swift
//
//  Created by Кирилл on 11.01.2022.
//

import WebKit
import GCDWebServer

class DebugSafariController: UIViewController {
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.ignoresViewportScaleLimits = true
        if #available(iOS 13.0, *) {
            config.defaultWebpagePreferences.preferredContentMode = .desktop
        }
        
        let webView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
       
        return webView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var port: Int = 8080
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .overFullScreen
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -12),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let address: String = GCDWebServerGetPrimaryIPAddress(false) ?? "127.0.0.1"
        if let fullUrl = URL(string: "http://\(address):\(port)") {
            titleLabel.text = fullUrl.absoluteString
            webView.load(URLRequest(url: fullUrl))
        }
    }
    
    @objc private func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
