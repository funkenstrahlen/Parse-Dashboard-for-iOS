//
//  FileViewController.swift
//  Parse Dashboard for iOS
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
//  Created by Nathan Tannar on 8/31/17.
//

import UIKit
import Photos
import DKImagePickerController

class FileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var schema: PFSchema
    private var key: String
    private var url: URL
    private var filename: String
    private var objectId: String
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "File")
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: - Initialization
    
    init(url: URL, filename: String, schema: PFSchema, key: String, objectId: String) {
        self.url = url
        self.filename = filename
        self.schema = schema
        self.key = key
        self.objectId = objectId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
        loadDataFromUrl()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        
        view.backgroundColor = .darkPurpleAccent
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    
    private func setupNavigationBar() {
        
        title = "File View"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(dismissInfo))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "Save"),
                            style: .plain,
                            target: self,
                            action: #selector(saveImage)),
            UIBarButtonItem(image: UIImage(named: "Upload"),
                            style: .plain,
                            target: self,
                            action: #selector(presentImagePicker))
        ]
    }
    
    // MARK: - Data Refresh
    
    func loadDataFromUrl() {
        
        let request = URLRequest(url: url)
        let downloadViewer = DownloadViewer(request: request)
        downloadViewer.tintColor = .darkPurpleAccent
        downloadViewer.backgroundColor = .darkPurpleBackground
        view.addSubview(downloadViewer)
        downloadViewer.anchorCenterToSuperview()
        downloadViewer.completionBlock = { [weak self] task, location in
            let data = NSData(contentsOf: location)
            DispatchQueue.main.async {
                guard let data = data else {
                    Ping(text: "Download Error", style: .danger).show(animated: true, duration: 3)
                    return
                }
                self?.imageView.image = UIImage(data: data as Data)
                self?.imageView.contentMode = .scaleAspectFill
            }
            try? FileManager.default.removeItem(at: location)
        }
        downloadViewer.downloadTask?.resume()
    }
    
    // MARK: - User Actions
    
    @objc
    func dismissInfo() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveImage() {
        
        guard let image = imageView.image else { return }
        if image == UIImage(named: "File") { return }
        PHPhotoLibrary.shared().performChanges( { PHAssetChangeRequest.creationRequestForAsset(from: image) }, completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    // "Saved to camera roll"
                    Toast(text: "Saved to camera roll").present(self, animated: true, duration: 3)
                } else {
                    // "Error saving to camera roll"
                    Ping(text: "Error saving to camera roll", style: .danger).show(animated: true, duration: 3)
                }
            }
        })
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    @objc
    func presentImagePicker() {
        
        let picker = DKImagePickerController()
        picker.assetType = .allPhotos
        picker.singleSelect = true
        picker.autoCloseOnSingleSelect = false
        picker.didSelectAssets = { assets in
            assets.first?.fetchOriginalImageWithCompleteBlock({ image, _ in
                let imageData = image != nil ? UIImageJPEGRepresentation(image!, 1) : nil
                Toast(text: "Uploading").present(self, animated: true, duration: 3)
                Parse.shared.post(filename: self.filename , classname:  self.schema.name, key: self.key, objectId: self.objectId, imageData: imageData, completion: { [weak self] (result, json) in
                    guard result.success else {
                        Ping(text: result.error ?? "Upload Failed", style: .success).show(animated: true, duration: 3)
                        return
                    }
                    self?.imageView.contentMode = .scaleAspectFill
                    self?.imageView.image = image
                })
            })
        }
        picker.navigationBar.isTranslucent = false
        picker.navigationBar.tintColor = .logoTint
        present(picker, animated: true, completion: nil)
    }

}
