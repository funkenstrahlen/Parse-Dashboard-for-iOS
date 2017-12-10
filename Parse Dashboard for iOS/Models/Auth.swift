//
//  Auth.swift
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

class Auth: NSObject {
    
    static var shared = Auth()
    
    // MARK: - Properties
    
    var accessEnabled: Bool {
        return isGranted || !isSetup
    }
    
    private var passkey: Int = 0
    
    private var isGranted: Bool = false
    
    private var isSetup: Bool = false
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        self.isSetup = UserDefaults.standard.bool(forKey: "isSetup")
        self.passkey = UserDefaults.standard.integer(forKey: "passkey")
    }
    
    // MARK: - Methods
    
    func unlock(over viewController: UIViewController) {
        
    }
    
    func lock() {
        isGranted = false
    }
    
    func destroy(over viewController: UIViewController) {
        isSetup = false
    }
}
