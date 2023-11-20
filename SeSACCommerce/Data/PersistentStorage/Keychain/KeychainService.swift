//
//  KeychainService.swift
//  SeSACCommerce
//
//  Created by 박태현 on 2023/11/19.
//

import Foundation
import Security

final class KeychainService {

    enum KeychainItem: String {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }

    static let shared = KeychainService()
    static let serviceID = Bundle.main.bundleIdentifier ?? ""

    var accessToken: String? {
        get {
            return read(Self.serviceID, account: KeychainItem.accessToken)
        }
    }

    var refreshToken: String? {
        get {
            return read(Self.serviceID, account: KeychainItem.refreshToken)
        }
    }


    private init() { }

    func create(_ service: String = serviceID, account: KeychainItem, value: String) {
        // Query
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account.rawValue,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)
        ]

        // Delete
        SecItemDelete(keyChainQuery)

        // Create
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "failed to saving token")
    }

    func read(_ service: String = serviceID, account: KeychainItem) -> String? {
         let KeyChainQuery: NSDictionary = [
             kSecClass: kSecClassGenericPassword,
             kSecAttrService: service,
             kSecAttrAccount: account.rawValue,
             kSecReturnData: kCFBooleanTrue,
             kSecMatchLimit: kSecMatchLimitOne
         ]
         // Read
         var dataTypeRef: AnyObject?
         let status = SecItemCopyMatching(KeyChainQuery, &dataTypeRef)

         // Read 성공 및 실패한 경우
         if(status == errSecSuccess) {
             let retrievedData = dataTypeRef as! Data
             let value = String(data: retrievedData, encoding: String.Encoding.utf8)
             return value
         } else {
             print("failed to loading, status code = \(status)")
             return nil
         }
     }

    // Delete
    func delete(_ service: String = serviceID, account: KeychainItem) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account.rawValue
        ]

        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }

}
