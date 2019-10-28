//
//  ViewController.swift
//  TextileDemo
//
//  Created by Max Rozdobudko on 27.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet fileprivate weak var displayNameTextField: UITextField! {
        didSet {
            displayNameTextField.delegate = self
            displayNameTextField.returnKeyType = .send
        }
    }

    // MARK: View model

    let viewModel = ViewModel()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func handleGetAccountDisplayNameButtonTap(_ sender: Any) {
        viewModel.getAccountDisplayName()
    }

    @IBAction func handleCreateTestThreadButtonTap(_ sender: Any) {
        viewModel.createTestThread()
    }

    @IBAction func handleWriteDataToTestThreadButtonTap(_ sender: Any) {
        viewModel.writeTestDataToTestThread()
    }

    @IBAction func handleReadDataFromTestThreadButtonTap(_ sender: Any) {
        viewModel.readDataFromTestThread()
    }

}

// MARK: -

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        defer {
            view.endEditing(false)
        }
        switch textField {
        case displayNameTextField:
            if let text = textField.text {
                viewModel.setAccount(displayName: text)
            }
        default:
            break
        }
        return false
    }

}
