//
//  KeyChainAuthRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/03.
//

import Foundation
import Security

class KeyChainAuthRepo {
    static let shared = KeyChainAuthRepo()
    
    func create(account: String, value: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
        ]
        SecItemDelete(keyChainQuery)
        let status = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "failed to saving Token")
    }
    
    func read(account: String) -> String? {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        if status == errSecSuccess {
            guard let fetchedData = dataTypeRef as? Data else { return nil }
            let value = String(data: fetchedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("failed to fetching, status code = \(status)")
            return nil
        }
    }
    
    func delete(account: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ]
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
