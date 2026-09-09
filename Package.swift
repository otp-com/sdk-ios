// swift-tools-version:5.9
import PackageDescription

// A distribution shell. There is no source here: the framework is built from the private
// otp-com/otp-mobile repository and attached to a GitHub release, and the two lines below point at it.
//
// `url` and `checksum` are managed by the release tooling, not by hand. They always name a published
// release, so a checkout of `main` resolves to a working artifact.
//
// swift-tools-version is 5.9 rather than 6.0 on purpose: this manifest only declares a binary target,
// so it does not need a newer toolchain, and requiring one would exclude projects that are otherwise
// perfectly able to consume the framework.
let package = Package(
  name: "Otp",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Otp", targets: ["Otp"])
  ],
  targets: [
    .binaryTarget(
      name: "Otp",
      url: "https://github.com/otp-com/sdk-ios/releases/download/0.1.0/Otp.xcframework.zip",
      checksum: "380b5b73b89d89700904a6381ecf1e3fe78ef5dee113b590ee99d7f52c72f75a"
    )
  ]
)
