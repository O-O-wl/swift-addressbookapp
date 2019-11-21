//
//  ContactService.swift
//  AddressBookApp
//
//  Created by 이동영 on 2019/11/22.
//  Copyright © 2019 이동영. All rights reserved.
//

import Contacts
import Foundation


class ContactService {
   
    // MARK: - Singtone
    static let shared = ContactService()
    
    // MARK: - Properties
    private let store = CNContactStore()
    private let contactAccessQueue = DispatchQueue(label: "ContactAccessQueue",
                                                   attributes: DispatchQueue.Attributes.concurrent)
    // MARK: - Initializdr
    private init() {}
    
    // MARK: - Methods
    func fetchContacts(_ completion: @escaping ([CNContact]) -> Void) {
        var result = [CNContact]()
        let keysToFetch = ContactKey.allCases.map { $0.descriptor }
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        request.sortOrder = .familyName
        
        contactAccessQueue.async {
            do {
                try self.store.enumerateContacts(with: request) { contact, status in
                    print(status)
                    result.append(contact)
                }
                
            } catch let error {
                print("Error \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
