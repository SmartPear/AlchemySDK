//
//  NetWorkApi.swift
//  ACHWallet
//
//  Created by edz on 2018/10/25.
//  Copyright © 2018 王欣. All rights reserved.
//

import UIKit
import Alamofire


public enum  AlcServerType:String{
    case release    =  "线上环境"
    case debug      =  "(内测版)"
    var url:String{
        switch self {
        case .release:
            return "http://13.250.21.97:9099/"
        case .debug:
            return "http://13.250.21.97:9099/"
        }
        
    }
}
var serverType = AlcServerType.debug
//通道地址
let AlcProXy = "0x0B14a96CbEd20797341EF18bE27Ec80b7B7e5F20"
enum AlcRouter:URLRequestConvertible{
 
    case getRaidenHistory(token:String,address:String)
    case getRaidenBalnce(token:String,address:String,proxy:String)
    case openChannel(token:String,address:String,proxy:String,amout:String);
    case channelPayment(token:String,address:String,proxy:String,amout:String,sysFlowNo:String);
    var path:String{
        switch self {
        case .getRaidenBalnce:
            return "raidenNetwork/customer/getChannelBalance"
        case .getRaidenHistory:
            return "raidenNetwork/customer/getOrderList"
        case .openChannel:
            return "raidenNetwork/customer/openChannel"
        case .channelPayment:
            return "raidenNetwork/customer/channelPayment";
        }
    }
    

    func asURLRequest() throws -> URLRequest {
        var url = serverType.url
        url.append(path);
        var urlRequest = URLRequest(url: URL.init(string: url)!);
        urlRequest.timeoutInterval = 10;
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData;
        var parameters = [String : Any]()
        switch self {
        case .getRaidenHistory(let token,let  address):
            parameters.updateValue(token, forKey: "token");
            parameters.updateValue(address, forKey: "userAddr");
        case .getRaidenBalnce(let token,let  address,let  proxy):
            parameters.updateValue(token, forKey: "token");
            parameters.updateValue(address, forKey: "userAddr");
            parameters.updateValue(proxy, forKey: "proxy");
        case .openChannel(let token, let address,let proxy,let amout):
            parameters.updateValue(token, forKey: "token");
            parameters.updateValue(address, forKey: "userAddr");
            parameters.updateValue(amout, forKey: "channelAmount");
            parameters.updateValue(proxy, forKey: "proxy");
        case .channelPayment(let token ,let address,let proxy, let amout,let sysFlowNo):
            parameters.updateValue(token, forKey: "token");
            parameters.updateValue(address, forKey: "userAddr");
            parameters.updateValue(amout, forKey: "channelAmount");
            parameters.updateValue(proxy, forKey: "proxy");
            parameters.updateValue(amout, forKey: "amount");
            parameters.updateValue(sysFlowNo, forKey: "sysFlowNo");
            print(parameters)
        }
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with:parameters)
        debugPrint(urlRequest)
        return urlRequest
        
    }
    
}

