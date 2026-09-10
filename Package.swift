// swift-tools-version:6.0
import PackageDescription

// A distribution shell. There is no source here: the framework is built from the private
// otp-com/otp-mobile repository and attached to a GitHub release, and the two lines below point at it.
//
// `url` and `checksum` are managed by the release tooling, not by hand. They always name a published
// release, so a checkout of `main` resolves to a working artifact.
//
// swift-tools-version is 6.0 because the framework's public interface uses typed throws, which only a
// Swift 6 compiler can read. It was 5.9 on the reasoning that a manifest declaring nothing but a
// binary target needs no newer toolchain. That is true of the manifest and false of the framework:
// Xcode 15 resolved the package and then failed at `import Otp`, which is a worse failure than being
// turned away at resolution with a version it can explain.
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
