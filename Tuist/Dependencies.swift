import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: [
        .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.3")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/SvenTiigi/YouTubePlayerKit.git", requirement: .upToNextMajor(from: "1.2.0")),
        .remote(url: "https://github.com/slackhq/PanModal.git", requirement: .upToNextMajor(from: "1.2.0")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",requirement: .upToNextMajor(from: "6.5.0")),
        .remote(url: "https://github.com/ReactorKit/ReactorKit.git",requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/ashleymills/Reachability.swift", requirement: .upToNextMajor(from: "5.1.0")),
        .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.3.0")),
        .remote(url: "https://github.com/layoutBox/FlexLayout.git", requirement: .upToNextMajor(from: "1.3.18")),
        .remote(url: "https://github.com/layoutBox/PinLayout", requirement: .upToNextMajor(from: "1.10.3")),
        .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "10.0.0")),
        .remote(url: "https://github.com/uber/needle.git", requirement: .upToNextMajor(from: "0.19.0"))
    ],
    platforms: [.iOS]
)