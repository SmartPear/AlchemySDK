//
//  Wallet.swift
//  ACHWallet
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018 王欣. All rights reserved.
//

import Foundation
import web3swift
import Result
import BigInt

public class Wallet: NSObject {
    
    var  walletName:String = "WALLET"
    var  address:String = ""
    var  keyStore:String = ""
    var  mnemonicPhrase:String = ""
    var  privateKey:String = ""
    var  passWord  = ""
    var  validWallt:Bool = false //是否是有效的钱包
    var tokens = [TokenModel]()
    
    
    
}

public class TokenModel: NSObject {
    //余额
    var  balanceValue:String = "0.0"
    var  token:String = ""
}

