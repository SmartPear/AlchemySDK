//
//  KeysService.swift
//  PeepethClient
//
//  Created by Георгий Фесенко on 06/07/2018.
//  Copyright © 2018 BaldyAsh. All rights reserved.
//

import Foundation
import web3swift

public enum TokenApi:String {
    case Eth    = "Ethreum"
    case ACH    = "0x822925476aF6C7baE9667C09161Ea84294be2500"
    case RTT    = "0x0f114A1E9Db192502E7856309cc899952b3db1ED"
    case VITE   = "0x0f114A1E9Db192502E7856309cc899952b3db1E1"
    case INS    = "0xd18da7B6E727f288aA056842723476284Beae36E"
    case INF    = "0x2608096B2aEbD85bc3c61444cA43dC136Cd5CEd8"
    case ACHRID = "0x0c79B0ebEbB65c0d15d9c1011626DA1B006736d8"

    func name () -> String {
        switch self {
        case .Eth:  return "Ethreum";
        case .ACH:  return "ACH";
        case .VITE: return "VITE";
        case .INS:  return "INS Promp";
        case .RTT:  return "RTT";
        case .INF:  return "INF";
        case .ACHRID :return "ACHRID"
        }
    }
    func subname () -> String {
        switch self {
        case .Eth:  return "ethreum";
        case .ACH:  return "ach";
        case .VITE: return "vite";
        case .INS:  return "insp";
        case .RTT:  return "rtt";
        case .INF:  return "inf";
        case .ACHRID: return "achrid"
        }
    }
    func imageNamed () -> String {
        switch self {
        case .Eth:  return "bi_eth";
        case .ACH:  return "bi_ach";
        case .VITE: return "bi_vite";
        case .INS:  return "bi_inspromo";
        case .RTT:  return "bi_raiden";
        case .INF:  return "bi_aion";
        case .ACHRID:  return "bi_ach";
        }
    }
}

