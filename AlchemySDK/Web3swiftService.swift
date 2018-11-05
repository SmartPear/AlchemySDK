////
////  Web3swiftService.swift
////  PeepethClient
////
//
import Foundation
import web3swift
import BigInt
import SwiftyJSON
import Alamofire


public enum WalletSavingError: Error {
    case couldNotSaveTheWallet
    case couldNotCreateTheWallet
    case couldNotGetTheWallet
    case couldNotGetAddress
    case couldNotGetThePrivateKey
}

public class Web3swiftService {
    public static let web3Service = Web3swiftService()
    public let web3 = Web3.InfuraRopstenWeb3();
    public var currentWallet:Wallet?
    
    
    /// 设置web服务默认的钱包
    ///
    /// - Parameter wallet: 传入钱包
    public func makeDefalutWallet(wallet:Wallet) {
        currentWallet = wallet;
        let privateKey = wallet.privateKey;
        let data = Data.init(hex: privateKey)
        
        do{
            guard let keyStore = try EthereumKeystoreV3.init(privateKey: data) else{
                print("添加keystore失败");
                return;
            }
            let keyStoreManager = KeystoreManager.init([keyStore]);
            web3.addKeystoreManager(keyStoreManager);
            print("添加keystore成功");
        }catch(let error){
            print("添加keystore失败\(error.localizedDescription)");
        }
        
    }
    
    
    /// 查询当前服务的钱包地址
    public var currentAddress: EthereumAddress? {
        if let wallet = currentWallet{
            let address = wallet.address;
            let ethAddressFrom = EthereumAddress(address)
            return ethAddressFrom
        }
        return nil;
    }
    
    
    /// 查询余额
    ///
    /// - Parameters:
    ///   - toKen: 设置token的类型
    ///   - queue: 设置线程，默认goble
    ///   - group: 传入线程组
    ///   - complete: 完成的回调
    //    func  GetBalanceWith(
    //        toKen:TokenApi = .Eth,
    //        queue:DispatchQueue = DispatchQueue.global(),
    //        group:DispatchGroup = DispatchGroup.init(),
    //        complete:@escaping ((_ value:String?,_ fromToken:TokenApi,_ error:Web3Error?)->Void)
    //        ) {
    //        if toKen == .Eth{
    //            guard let WALLET = currentWallet else{
    //                return;
    //            }
    //            let address = WALLET.address;
    //            guard let coldWalletAddress = EthereumAddress.init(address) else{
    //                return;
    //            }
    //            queue.async(group: group){
    //                let balance = self.web3.eth.getBalance(address: coldWalletAddress);
    //
    //                DispatchQueue.main.async {
    //                    complete(String.init(balance.value ?? "0.0"),toKen,balance.error);
    //                }
    //
    //            }
    //        }else{
    //            let coldEthAddress = self.currentAddress;
    //            var options = Web3Options.defaultOptions()
    //            options.from = coldEthAddress;
    //            guard let contractAddress = EthereumAddress(toKen.rawValue) else{
    //                DispatchQueue.main.async {
    //                complete("0.0",toKen,Web3Error.walletError);
    //                }
    //                return;
    //            }
    //            print(contractAddress);
    //            // BKX token on Ethereum mainnet
    //            queue.async(group: group){
    //
    //                let contract = self.web3.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)!
    //                guard let balance = contract.method("balanceOf", parameters: [coldEthAddress] as [AnyObject], options: options)?.call(options: nil) else{
    //                    DispatchQueue.main.sync {
    //                        complete("0.0",toKen,Web3Error.connectionError);
    //                    }
    //                    return;
    //                }
    //                guard let intermediate = contract.method("decimals", options: options) else {
    //                    DispatchQueue.main.sync {
    //                        complete("0.0",toKen,Web3Error.connectionError);
    //                    }
    //                    return;
    //                }
    //                let callResult = intermediate.call(options: options, onBlock: "latest")
    //                var decimals = BigUInt(0)
    //                switch callResult {
    //                case .success(let response):
    //                    guard let dec = response["0"], let decTyped = dec as? BigUInt else {
    //                        return
    //                    }
    //                    decimals = decTyped
    //                    break
    //                case .failure(let error):
    //                    complete("0.0",toKen,error);
    //                    break
    //                }
    //                let intDecimals = Int(decimals)
    //                switch balance.result{
    //
    //                case .success(let value):
    //
    //                    let weiSting = String.init(value["0"] as? BigUInt ?? "0")
    //                    let floatValue = Double.init(weiSting);
    //                    let value = floatValue! / Double(powf(10, Float(intDecimals)));
    //                    let valueStr = "\(value)"
    //                    DispatchQueue.main.async {
    //                    complete(valueStr,toKen,nil);
    //                    }
    //                case .failure(let error):
    //                    DispatchQueue.main.async {
    //                    complete("0.0",toKen,error);
    //                    }
    //                    print(error);
    //                }
    //            }
    //        }
    //    }
    
    /// 发送交易
    ///
    /// - Parameters:
    ///   - toAddress: 发送交易的地址
    ///   - amount: 交易的数额
    ///   - gasLimit: gaslimit
    ///   - gasPrice:
    ///   - token:
    ///   - completion: 完成的回调
    //    func sendTranstion(
    //        toAddress:String,
    //        amount:String,
    //        gasLimit:BigUInt = BigUInt(21000),
    //        gasPrice:BigUInt = BigUInt(1000),
    //        token:TokenApi = TokenApi.Eth,
    //        completion:@escaping (_ result:TransactionSendingResult?,_ error:Web3Error?)->Void
    //        ){
    //
    //        let fromAddress = self.currentWallet?.address;
    //        guard let toEthaddress   = EthereumAddress.init(toAddress) else{
    //            let err = Web3Error.inputError(desc: "地址有误")
    //            completion(nil,err);
    //            return;
    //        }
    //        guard let fromEthAddress = EthereumAddress.init(fromAddress!) else{
    //            let err = Web3Error.inputError(desc: "地址有误")
    //            completion(nil,err);
    //            return;
    //        }
    //        let wei = try? getWeiBigStringFrom(ethString:amount)
    //        let value = BigUInt.init(wei ?? "0")
    //
    //        var options = Web3Options.defaultOptions()
    //        options.gasLimit = gasLimit
    //        options.from = fromEthAddress;
    //        DispatchQueue.global().async {
    //            if let currentGasPrice =  self.web3.eth.getGasPrice().value {
    //                options.gasPrice = currentGasPrice;
    //            }else{
    //                options.gasPrice = gasPrice;
    //            }
    //
    //            let newData = Data.init()
    //            if token == TokenApi.Eth{
    //                let transication =  self.web3.eth.sendETH(to: toEthaddress, amount: value ?? BigUInt(0), extraData: newData, options: options);
    //                let result =  transication?.send().result//发送交易
    //
    //                DispatchQueue.main.async {
    //                    switch result {
    //                    case .success(let r)?:
    //                        completion(r,nil);
    //                        print("Sucess",r)
    //                    case .failure(let err)?:
    //                        completion(nil,err);
    //                        print("Eroor",err)
    //                    case .none:
    //                        let err = Web3Error.inputError(desc: "未知错误")
    //                        completion(nil,err);
    //                        print("aaaaa")
    //                    }
    //                }
    //            }else{
    //                // there are also convenience functions to send ETH and ERC20 under the .eth structure
    //                if let convenienceTokenTransfer = self.web3.eth.sendERC20tokensWithNaturalUnits(tokenAddress: EthereumAddress(token.rawValue)!, from: fromEthAddress, to: EthereumAddress(toAddress)!, amount: amount, options: options) {
    //                    let result =  convenienceTokenTransfer.send().result;
    //
    //                    DispatchQueue.main.async {
    //                        switch result.result{
    //                        case .failure(let error):
    //                            completion(nil,error);
    //                        case .success(let valueSTR):
    //                            completion(valueSTR,nil);
    //                        }
    //                    }
    //
    //                }else{
    //                    completion(nil,Web3Error.connectionError);
    //                }
    //            }
    //        }
    //    }
    //
    //获取交易手续费
    public func GetGasPrice(complete:@escaping (_ totalGasPrice:String)->Void) {
        DispatchQueue.global().async {
            let currentGasPrice =  self.web3.eth.getGasPrice();
            let gasLimit = BigUInt(21000);
            var totalGas = BigUInt.init(0);
            switch currentGasPrice.result {
            case .success(let value):
                totalGas = value * gasLimit;
                let eth = Web3Utils.formatToEthereumUnits(totalGas, toUnits: .eth, decimals: 8, decimalSeparator: ".")
                DispatchQueue.main.async {
                    complete(eth ?? "0");
                }
            case .failure(_):
                totalGas = gasLimit * BigUInt(1000);
                let eth = Web3Utils.formatToEthereumUnits(totalGas, toUnits: .eth, decimals: 8, decimalSeparator: ".")
                DispatchQueue.main.async {
                    complete(eth ?? "0");
                }
            }
        }
    }
    
    /// 创建钱包
    ///
    /// - Parameters:
    ///   - password: 传入密码
    ///   - completion: 完成回调
    public func createWalletWith(password: String, completion:@escaping(( _ wallet:Wallet?, _ error: Error?)->Void)) {
        DispatchQueue.global().async {
            //生成随机的助记词
            guard  let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 128, language: BIP39Language.english) else{
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return;
            }
            let seed = BIP39.seedFromMmemonics(mnemonic);
            guard let keyStore = try? BIP32Keystore.init(seed: seed!, password: password) else{
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return;
            }
            let manager = KeystoreManager.init([keyStore!]);
            let accout = manager.addresses?.first;
            guard let privateKey  = try! keyStore?.UNSAFE_getPrivateKeyData(password: password, account: accout!) else{
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return;
            }
            guard let keydata = try? JSONEncoder().encode(keyStore?.keystoreParams) else {
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return
            }
            
            guard let keyStoreJson = String.init(data: keydata, encoding: .utf8) else{
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return;
            }
            let walletModel = Wallet.init();
            walletModel.address = accout!.address
            walletModel.passWord = password;
            walletModel.privateKey = privateKey.toHexString();
            walletModel.keyStore = keyStoreJson
            walletModel.mnemonicPhrase = mnemonic;
            print(walletModel.keyStore);
            completion(walletModel, nil)
        }
    }
    
    
    /// 私钥导入钱包
    ///
    /// - Parameters:
    ///   - privateKey: 私钥
    ///   - passWord: 传入密码
    ///   - completion: 完成回调
    public  func importWalletWith(privateKey:String,passWord:String,completion:@escaping(( _ wallet:Wallet?, _ error: Error?)->Void))  {
        DispatchQueue.global().async {
            guard let data = Data.fromHex(privateKey) else {
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return
            }
            guard let newWallet = try? EthereumKeystoreV3(privateKey: data, password: passWord) else {
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return
            }
            guard let wallet = newWallet, wallet.addresses?.count == 1 else {
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return
            }
            guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return
            }
            guard let address = newWallet?.addresses?.first?.address else {
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return
            }
            let privateKey = try! newWallet?.UNSAFE_getPrivateKeyData(password: passWord, account: EthereumAddress.init(address)!);
            let keyStore = try! JSON.init(data: keyData);
            let walletModel = Wallet.init();
            walletModel.address = address;
            walletModel.passWord = passWord;
            walletModel.privateKey = (privateKey?.toHexString())!;
            walletModel.keyStore = keyStore.rawString()!;
            completion(walletModel, nil)
        }
        
    }
    
    
    
    
    /// 官方keystore导入钱包
    ///
    /// - Parameters:
    ///   - jsonString: 官方keystore
    ///   - passWord: 传入密码
    ///   - completion: 完成回调
    public  func importWalletWith(keystore jsonString:String,passWord:String,completion:@escaping(( _ wallet:Wallet?, _ error: Error?)->Void))  {
        
        DispatchQueue.global().async {
            guard let account = EthereumKeystoreV3.init(jsonString) else{
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return;
            }
            guard let address = account.addresses?.first?.address else{
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return;
            }
            guard let wallet  = EthereumAddress.init(address) else { return };
            guard let privateKey = try? account.UNSAFE_getPrivateKeyData(password: passWord, account: wallet) else{
                completion(nil, WalletSavingError.couldNotSaveTheWallet)
                return;
            }
            let walletModel = Wallet.init();
            walletModel.address = address;
            walletModel.passWord = passWord;
            walletModel.privateKey = privateKey.toHexString();
            walletModel.keyStore = jsonString
            completion(walletModel, nil)
        }
        
    }
    
    
    /// 助记词导入钱包
    ///
    /// - Parameters:
    ///   - str: 助记词
    ///   - passWord: 密码
    ///   - completion: 完成回调
    public  func importWallet(mnemtion str:String,pass passWord:String ,completion:@escaping(( _ wallet:Wallet?, _ error: Error?)->Void)) {
        DispatchQueue.global().async {
            //生成随机的助记词
            
            guard let seed = BIP39.seedFromMmemonics(str) else{
                return;
            }
            guard let keyStore = try? BIP32Keystore.init(seed: seed, password: passWord) else{
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return;
            }
            let manager = KeystoreManager.init([keyStore!]);
            let accout = manager.addresses?.first;
            guard let privateKey  = try! keyStore?.UNSAFE_getPrivateKeyData(password: passWord, account: accout!) else{
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return;
            }
            guard let keydata = try? JSONEncoder().encode(keyStore?.keystoreParams) else {
                completion(nil, WalletSavingError.couldNotCreateTheWallet)
                return
            }
            
            let keyStoreJson = try! JSON.init(data: keydata);
            let walletModel = Wallet.init();
            walletModel.address = accout!.address
            walletModel.passWord = passWord;
            walletModel.privateKey = privateKey.toHexString();
            walletModel.keyStore = keyStoreJson.rawString()!;
            walletModel.mnemonicPhrase = str;
            print(walletModel.keyStore);
            completion(walletModel, nil)
        }
    }
    
    //创建通道
    public  func createChannelWithAmout(amout:String,tokenapi:TokenApi,completion:@escaping((_ value:Any,_ error:Any)->Void)) {
//        guard let address = self.currentAddress?.address else{
//            completion("","地址错误");
//            return;
//        }
        //        self.sendTranstion(toAddress: AlcProXy, amount: amout,token: tokenapi) {
        //            [weak self] (resulet, error) in
        //
        //            if error == nil{
        //                self?.openChannelAction(amout: amout, tokenapi: tokenapi, address: address, completion: completion);
        //            }else{
        //                completion("",error as Any);
        //            }
        //        }
    }
    
    //通道充值
    public  func RechargeChannelWithAmout(amout:String,tokenapi:TokenApi,completion:@escaping((_ value:Any,_ error:Any)->Void)) {
//        guard let address = self.currentAddress?.address else{
//            completion("","地址错误");
//            return;
//        }
        //        self.sendTranstion(toAddress: AlcProXy, amount: amout,token: tokenapi) {
        //            [weak self] (resulet, error) in
        //
        //            if error == nil{
        //                self?.openChannelAction(amout: amout, tokenapi: tokenapi, address: address, completion: completion);
        //            }else{
        //                completion("",error as Any);
        //            }
        //        }
    }
    
    public  func openChannelAction(amout:String,tokenapi:TokenApi,address:String,completion:@escaping((_ value:Any,_ error:Any)->Void)) {
        request(AlcRouter.openChannel(token: tokenapi.rawValue, address: address, proxy: AlcProXy, amout: amout)).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value);
                completion(value,"");
            case .failure(let error):
                completion("",error);
                print(error);
            }
        }
    }
    
    //查询通道余额
    public  func requsetChannelBalance(token:TokenApi,completion:@escaping ((DataResponse<Any>) -> Void)) {
//        let addres = self.currentWallet?.address;
//
//        request(AlcRouter.getRaidenBalnce(token: token.rawValue, address: addres ?? "", proxy: AlcProXy)).responseJSON { (response) in
//            completion(response);
//        }
    }
    
    
}
//从ETH 转换为 Wei
func getWeiBigStringFrom(ethString:String) throws -> String {
    let eth = Web3.Utils.parseToBigUInt(ethString, units: .eth);//当前是eth
    if (nil == eth) {
        return ""
    } else {
        let balString =  Web3.Utils.formatToEthereumUnits(eth!, toUnits: .wei, decimals: 0)
        return balString!
    }
}
