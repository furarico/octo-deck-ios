//
//  KeychainHelper.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/15.
//

import Foundation

enum KeychainHelper {
    static func read(service: String, account: String) throws -> String {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        guard
            let data = (result as? Data),
            let string = String(data: data, encoding: .utf8)
        else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecItemNotFound), userInfo: nil)
        }

        return string
    }

    static func write(_ data: Data, service: String, account: String) throws {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary

        let matchingStatus = SecItemCopyMatching(query, nil)
        switch matchingStatus {
        case errSecItemNotFound:
            let status = SecItemAdd(query, nil)
            guard status == noErr else {
                throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
            }
        case errSecSuccess:
            SecItemUpdate(query, [kSecValueData as String: data] as CFDictionary)
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(matchingStatus), userInfo: nil)
        }
    }

    static func delete(service: String, account: String) throws {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemDelete(query)
        guard status == noErr else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
        }
    }
}
