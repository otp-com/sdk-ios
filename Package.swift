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
      checksum: "85e6aafda53777fed00e2b734c24a935b2064e4be26dc0b7fe1acbe833cb0661"
    )
  ]
)
