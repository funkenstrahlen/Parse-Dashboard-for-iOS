//
//  AuthViewController.swift
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
//  Created by Nathan Tannar on 12/4/17.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(dismissAuth))
    }
    
    // MARK: - Handlers
    
    func handleError(_ error: String?) {
        let error = error?.capitalized ?? "Unexpected Error"
        let ping = Ping(text: error, style: .danger)
        print(error)
        ping.show(animated: true, duration: 3)
    }
    
    func handleSuccess(_ message: String?) {
        let message = message?.capitalized ?? "Success"
        let ping = Ping(text: message, style: .success)
        print(message)
        ping.show(animated: true, duration: 3)
    }
    
    // MARK: - User Actions
    
    @objc
    func dismissAuth() {
        dismiss(animated: true, completion: nil)
    }
    
//    private func authenticateUser() {
//
//        guard let isProtected = UserDefaults.standard.value(forKey: .isProtected) as? Bool else {
//            promptAuthSetup(completion: { enabled in
//                if enabled {
//                    self.authenticateWithPassword(completion: { _ in })
//                } else {
//                    self.fetchServersFromCoreData()
//                }
//            })
//            return
//        }
//        if isProtected {
//            // Auth required
//            if BioMetricAuthenticator.canAuthenticate() {
//                authenticateWithBiometrics()
//            } else {
//                authenticateWithPassword(completion: { success in
//                    if success {
//                        self.fetchServersFromCoreData()
//                    } else {
//                        self.handleError("Incorrect Password")
//                    }
//                })
//            }
//        } else {
//            // Auth not required
//            fetchServersFromCoreData()
//        }
//    }
//
//    private func authenticateWithBiometrics() {
//        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
//            self.fetchServersFromCoreData()
//        }) { error in
//            if error == .fallback || error == .biometryLockedout {
//                self.au
//            }
//            self.handleError(error.message())
//        }
//    }
//
//    private func authenticateWithPassword(completion: @escaping (Bool)->Void) {
//        let alert = UIAlertController(title: "Authentication", message: "Please enter your password", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            let password = alert.textFields?.first?.text
//            completion(self.canAuthenticate(with: password))
//        }))
//        alert.addTextField {
//            $0.placeholder = "Password"
//            $0.isSecureTextEntry = true
//        }
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func promptAuthSetup(completion: ((Bool)->Void)?) {
//        let alert = UIAlertController(title: "Security", message: "Do you want to enable server access authentication", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Disable", style: .destructive, handler: { _ in
//            UserDefaults.standard.set(false, forKey: .isProtected)
//            UserDefaults.standard.set(nil, forKey: .password)
//            completion?(false)
//        }))
//        alert.addAction(UIAlertAction(title: "Enable", style: .default, handler: { _ in
//            UserDefaults.standard.set(true, forKey: .isProtected)
//            completion?(true)
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func canAuthenticate(with password: String?) -> Bool {
//        guard let password = password else { return false }
//        guard let savedPassword = UserDefaults.standard.value(forKey: .password) as? String else {
//            UserDefaults.standard.set(password, forKey: .password) // Set the initial password
//            return canAuthenticate(with: password)
//        }
//        return password == savedPassword
//    }
//
//    @objc
//    private func toggleAuthRequired() {
//        guard let isProtected = UserDefaults.standard.value(forKey: .isProtected) as? Bool else {
//            authenticateUser()
//            return
//        }
//        if isProtected {
//            authenticateWithPassword(completion: { success in
//                if success {
//                    self.fetchServersFromCoreData()
//                    self.promptAuthSetup(completion: nil)
//                } else {
//                    self.handleError("Incorrect Password")
//                }
//            })
//        } else {
//            if BioMetricAuthenticator.canAuthenticate() {
//                authenticateWithBiometrics()
//            } else {
//                authenticateWithPassword(completion: { _ in })
//            }
//        }
//    }
}
