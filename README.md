# otp.com iOS SDK

Verifies a phone number or an email address with a one-time code. The channel is chosen by your
account routing, so you pass the recipient and nothing else.

Requires **iOS 15** and Xcode 16 or later.

## Before you start

You need two keys, and they are not interchangeable.

1. Sign in at [panel.otp.com](https://panel.otp.com?utm_source=github-sdk-ios). If you do not have an
   account yet, [create one](https://panel.otp.com/signup?utm_source=github-sdk-ios); it takes a
   minute and comes with sandbox credit.
2. Open your app, then **API Keys**, and create two:
   - a **publishable key** (`otp_pk_live_…`) for this SDK, which goes in your app;
   - a **server key** (`otp_live_…`) for your own backend, which never leaves it.
3. While you are integrating, use the `otp_pk_test_…` and `otp_test_…` pair instead. Sandbox sends no
   real messages and costs nothing.

The publishable key is meant to be readable: it ships inside your app, it is scoped to that one app,
and it can only start and answer verifications. It cannot read a recipient and it cannot exchange a
verification, which is why the server key exists and why it stays on your server.

## Install

Swift Package Manager, in Xcode under **File > Add Package Dependencies**:

```
https://github.com/otp-com/sdk-ios
```

Or in a `Package.swift`:

```swift
.package(url: "https://github.com/otp-com/sdk-ios", from: "0.1.0")
```

CocoaPods:

```ruby
pod 'Otp'
```

The framework is static. If you add `Otp.xcframework` to a target by hand, set it to **Do Not Embed**
under **General > Frameworks, Libraries, and Embedded Content**. Xcode defaults to **Embed & Sign**,
which copies a static archive into your app bundle and can fail App Store validation. Swift Package
Manager and CocoaPods set this correctly on their own.

## Use it

Configure once, at launch:

```swift
import Otp

OtpClient.configure(publishableKey: "otp_pk_live_…")
```

Then run a verification. This presents a screen, sends the code, takes the user's input, and returns
when it is done:

```swift
let verification = try await OtpClient.verify(recipient: "+14155552671")
```

If your flow has no phone field yet, let the SDK collect it:

```swift
let verification = try await OtpClient.verify(collecting: .phone)   // or .email
```

The message and the screen follow the same locale, so they never disagree. It defaults to the
device's; pass one to override:

```swift
let verification = try await OtpClient.verify(recipient: recipient, locale: "tr-TR")
```

## The one thing to get right

**`verification.token` is the result. Nothing else is.**

Send it to your own backend, which exchanges it with your **server** key:

```
POST https://api.otp.com/api/v1/verifications/exchange
Authorization: Bearer otp_live_…

{ "verification_token": "…" }
```

It answers with what was actually verified:

```json
{
  "otp_id": "6f0d2c5e-1c3a-4f1b-9a2e-6a1f2b3c4d5e",
  "recipient": "+14155552671",
  "recipient_type": "phone",
  "channel": "sms",
  "verified_at": "2026-09-08T19:33:21Z"
}
```

Until you make that call, your backend knows nothing. A success read off a device you do not control
is not evidence, and anyone running a modified build can claim any outcome they like. The token is
short-lived and single-purpose, so treat it as the only thing you trust.

Our [backend SDKs](https://github.com/otp-com?utm_source=github-sdk-ios) do this call for you in
Node, PHP, Go and Python.

## Resuming

On the WhatsApp channel the code is not sent until the user messages us, which means they leave your
app and iOS may terminate it while they are away. Call this when your app becomes active and they
come back to the screen they left:

```swift
if let verification = try await OtpClient.resumeInterrupted() {
    // finish the sign-in
}
```

It returns `nil` when there was nothing in flight.

## Your own screen

The drop-in screen has one layout and one thing you can change: the accent colour, from your panel.
There is no view-slot API, because a screen assembled from someone else's slots is worse than one you
wrote. If you want a different screen, build it on the same core the drop-in uses:

```swift
let session = OtpSession()
let pending = try await session.start(recipient: "+14155552671")

pending.codeLength          // how many boxes to draw
pending.expiresAt           // count down from this
pending.resendAvailableAt   // nil means it can never be resent
pending.handoffURL          // WhatsApp only: open this, the code follows

switch try await session.submit(code: enteredCode) {
case .verified(let verification):
    // verification.token
case .rejected(let attemptsRemaining):
    // a wrong code is an outcome, not an error
@unknown default:
    break
}
```

Everything the screen needs is on `PendingOtp`, so no part of this polls.

The `@unknown default` is not boilerplate. The SDK ships as a resilient binary so its enums can gain
cases without breaking apps already on the App Store, and Swift asks you to say what happens if one
does. The same applies to `OtpChannel`, `OtpStatus`, `OtpError.Kind` and `RecipientKind`. Leave it out
and you get a warning today and an error under the Swift 6 language mode.

## Device integrity

The SDK registers a hardware-backed key with Apple's App Attest on first use and signs every send
with it. That is what stops a publishable key lifted out of your binary from being used outside your
app.

You do not have to configure anything for this. Two consequences worth knowing:

- **App Attest is unavailable on the simulator.** If your app has **Require a device proof** enabled
  in the panel, sends from a simulator are refused. The SDK logs one line saying so.
- Turn the panel setting on only once your integration is live, because any app version that does not
  register a key stops working when you do.

`DeviceProof.isSupported` tells you whether this device can produce a proof at all, which is the first
thing to check when a send is refused on hardware you expected to work.

## Errors

Everything throws `OtpError`. Read `kind` to decide what to do and show `message` only in your logs:
it is written for you, not for your user, and it is not translated.

```swift
do {
    let verification = try await OtpClient.verify(recipient: recipient)
} catch {
    // `error` is already an OtpError. The SDK uses typed throws, so there is nothing to cast.
    switch error.kind {
    case .cancelled:       break                      // the user closed the screen
    case .rateLimited:     wait(error.retryAfter)      // seconds, when the API sent one
    case .validationFailed: showYourOwnFieldError()
    default:               log(error)
    }
}
```

The screen the SDK presents already speaks English, Turkish, Russian, Arabic, German and French, and
follows the `locale` you pass rather than the device language, so the screen and the message agree.

## Support

Docs and status: [otp.com](https://otp.com?utm_source=github-sdk-ios). Anything else:
info@otp.com.
