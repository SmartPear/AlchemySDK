Pod::Spec.new do |s|
s.name             = "AlchemySDK"
s.version          = "0.0.5"
s.summary          = "Web3 implementation in vanilla Swift for iOS ans macOS"
s.description      = <<-DESC
钱包创建和交易查询，包括雷电网络一些基础功能的应用，通过该SDK可以快速集成以太坊钱包功能
DESC

s.homepage         = "https://github.com/wangxin1991/AlchemySDK"
s.license          = 'Apache License 2.0'
s.author           = { "wangxin" => "573385822@qq.com" }
s.source           = { :git => 'https://github.com/wangxin1991/AlchemySDK.git', :tag => s.version.to_s }

s.swift_version = '4.2'
s.module_name = 'AlchemySDK'
s.ios.deployment_target = "9.0"
s.source_files = "AlchemySDK/**/*.{h,swift}",
s.public_header_files = "AlchemySDK/**/*.{h}"
s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

s.frameworks = 'CoreImage'
s.dependency 'web3swift', '~> 1.5.1'
s.dependency 'Alamofire'
s.dependency 'SwiftyJSON'
end

