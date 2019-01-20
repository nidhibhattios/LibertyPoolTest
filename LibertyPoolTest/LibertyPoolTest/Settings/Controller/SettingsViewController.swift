//
//  SettingsViewController.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 19/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    let viewModel = SettingViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        guard let walletName = nameTextField.text else { return }
        guard let address = addressTextField.text else { return }
        
        UserDefaults.standard.set(walletName, forKey: UserDefaultConstants.transactionWalletName)
        UserDefaults.standard.set(address, forKey: UserDefaultConstants.transactionAddress)
        UserDefaults.standard.synchronize()
        self.showAlert(title: "Success", message: "Setting updated successfully")
        
        let name = UserDefaultConstants.settingUpdateNotification
        NotificationCenter.default.post(name: name, object: nil)
    }
}

extension SettingsViewController {
    func setupView() {
        self.title = "Settings"
        self.nameTextField.text = UserDefaults.standard.value(forKey: UserDefaultConstants.transactionWalletName) as? String ?? ""
        self.addressTextField.text = UserDefaults.standard.value(forKey: UserDefaultConstants.transactionAddress) as? String ?? ""
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.walletName)
            .disposed(by: disposeBag)
        
        addressTextField.rx.text
            .orEmpty
            .bind(to: viewModel.address)
            .disposed(by: disposeBag)
        
        viewModel.isValidate.map { $0 }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
