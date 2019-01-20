//
//  SettingViewModel.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 19/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SettingViewModel {
    
    var walletName = BehaviorRelay<String>(value: "")
    var address = BehaviorRelay<String>(value: "")
    
    var isValidate: Observable<Bool> {
        return Observable.combineLatest(self.walletName.asObservable(), self.address.asObservable()) { (wallet, address) in
            return wallet.count > 0 && address.count > 0
        }
    }
}
