//
//  ViewController.swift
//  CryptoSwift Test
//
//  Created by Rustam Manafli on 21.07.23.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pincode = "859674"
        let saltBase64 = "5yrNsQjNuW5NuwMwhmH+Wg=="
        let saltData = Data(base64Encoded: saltBase64)!

        let derivedPin = derivePincode(pincode: pincode, salt: saltData)

        print("⚠️", derivedPin)
    }
    
    func derivePincode(pincode: String, salt: Data) -> String {
        let N = 16384
        let r = 8
        let p = 1
        let keyLength = 32
        
        let password: Array<UInt8> = Array(pincode.utf8)
        let saltBytes: Array<UInt8> = Array(salt)
        
        do {
            let scrypt = try Scrypt(password: password, salt: saltBytes, dkLen: keyLength, N: N, r: r, p: p)
            
            let startTime = Date()
            let derivedKey = try scrypt.calculate()
            let endTime = Date()
            
            let timeInterval = endTime.timeIntervalSince(startTime)
            print("🕓 Key derivation took \(timeInterval) seconds.")
            
            let derivedPin = derivedKey.toBase64()
            return derivedPin
        } catch {
            print("Error: \(error)")
        }
        
        return ""
    }
}

