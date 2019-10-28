//
//  ViewModel.swift
//  TextileDemo
//
//  Created by Max Rozdobudko on 27.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Textile
import Textile.ThreadsApi

class ViewModel {

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Profile

    func getAccountDisplayName() {
        var error: NSError?
        let name = Textile.instance().profile.name(&error)
        if let error = error {
            print(error.localizedDescription)
        } else {
            print(name)
        }
    }

    func setAccount(displayName name: String) {
        var error: NSError?
        Textile.instance().profile.setName(name, error: &error)
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("display name updated")
        }
    }

    // MARK: - Thread

    func createTestThread() {
        guard retrieveTestThreadIfCreated() == nil else {
            return
        }
        var error: NSError?
        let schema = AddThreadConfig_Schema()
        schema.preset = .blob
        let config = AddThreadConfig()
        config.key = "com.github.rozd.playground.textile.demo.thread.Test"
        config.name = "Test"
        config.type = .private
        config.sharing = .notShared
        config.schema = schema
        let thread = Textile.instance().threads.add(config, error: &error)
        if let error = error {
            print(error)
        } else {
            print("thread created \(thread)")
        }
    }

    func retrieveTestThreadIfCreated() -> Any? {
        var error: NSError?
        let threads = Textile.instance().threads.list(&error)
        guard let thread = threads.itemsArray.firstObject else {
            if let error = error {
                print(error.localizedDescription)
            }
            return nil
        }
        print("found thread \(thread)")
        return thread
    }

    // MARK: - Files

    func writeTestDataToTestThread() {
        guard let data = "{ \"feedback\": \"test feedback\", \"rating\": 4 }".data(using: .utf8) else {
            return
        }

        Textile.instance().files.addData(data.base64EncodedString(), threadId: "12D3KooWJ9GS47SSohFYpRBN16hE6wkR1uL3cQmtwYPDkbUg6VEV", caption: "test data") { (block, error) in
            guard let block = block else {
                print(error.localizedDescription)
                return
            }
            print("data successfully written into block \(block)")
        }
    }

    func readDataFromTestThread() {
        var error: NSError?
        let filesList = Textile.instance().files.list("12D3KooWJ9GS47SSohFYpRBN16hE6wkR1uL3cQmtwYPDkbUg6VEV", offset: nil, limit: 10, error: &error)
        if let error = error {
            print(error.localizedDescription)
        } else {
            guard let files = filesList.itemsArray.firstObject as? Files else {
                print("WARN unable to find any files")
                return
            }
            if let file = files.filesArray.firstObject as? File {
                Textile.instance().files.content(file.file.hash_p) { (data, caption, error) in
                    guard let data = data else {
                        print(error.localizedDescription)
                        return
                    }
                    guard let json = String(data: data, encoding: .utf8) else {
                        print("ERROR unable to decode file data as UTF8 string")
                        return
                    }
                    print("file read sucessfully: \(json)")
                }
            }
        }

    }
}
