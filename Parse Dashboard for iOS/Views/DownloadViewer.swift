//
//  DownloadViewer.swift
//  DownloadViewer
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 11/30/17.
//

import UIKit

open class DownloadViewer: UIView, URLSessionDownloadDelegate {
    
    // MARK: - Properties [Public]
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            pulseLayer.cornerRadius = cornerRadius
        }
    }
    
    open var progress: CGFloat = 0 {
        didSet {
            progressLabel.text = "\(Int(progress * 100))%"
        }
    }
    
    private(set) open var downloadTask: URLSessionDownloadTask?
    
    open lazy var completionBlock: (_ task: URLSessionTask, _ location: URL)->Void = { [weak self] in
        return { task, location in
            try? FileManager.default.removeItem(at: location)
        }
    }()
    
    open let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    open let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Downloading"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Properties [Private]
    
    private let pulseLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = nil
        layer.borderWidth = 20
        layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.3).cgColor
        return layer
    }()
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "me.nathantannar.Parse-Dashboard.background.\(UUID().uuidString)")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: - Initialization
    
    public required init(request: URLRequest) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        downloadTask = session.downloadTask(with: request)
        setup()
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: - Setup [Private]
    
    private func setup() {
        
        addSubview(progressLabel)
        addSubview(stateLabel)
        
        progressLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stateLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        stateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        layer.addSublayer(pulseLayer)
        setupAnimations()
    }
    
    private func setupAnimations() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1.05
        pulseAnimation.toValue = 1.2
        pulseAnimation.duration = 0.75
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayer.add(pulseAnimation, forKey: "transform.scale")
    }
    
    // MARK: - Setup [Public]
    
    open func setupViews() {
        
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        backgroundColor = tintColor
        layer.borderWidth = 15
        layer.borderColor = tintColor.cgColor
    }
    
    // MARK: - Methods [Public]
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        layer.borderColor = tintColor.cgColor
        pulseLayer.borderColor = tintColor.withAlphaComponent(0.3).cgColor
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        cornerRadius = layer.bounds.width / 2
        pulseLayer.contentsCenter = layer.contentsCenter
        pulseLayer.frame = layer.bounds
    }
    
    // MARK: - URLSessionDownloadDelegate
    
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        DispatchQueue.main.async {
            self.progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        }
    }
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        DispatchQueue.main.async {
            self.stateLabel.text = error == nil ? "Complete" : "Error"
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        completionBlock(downloadTask, location)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.15, options: .curveEaseIn, animations: { [weak self] in
                self?.progressLabel.alpha = 0
                self?.stateLabel.alpha = 0
                self?.backgroundColor = self?.tintColor
                self?.transform = CGAffineTransform(scaleX: 5, y: 5)
                self?.alpha = 0
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
                self?.session.finishTasksAndInvalidate()
            })
        }
    }
}
