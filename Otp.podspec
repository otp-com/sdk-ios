Pod::Spec.new do |s|
  s.name              = 'Otp'
  s.version           = '0.2.0'
  s.summary           = 'Phone and email verification for iOS.'
  s.description       = <<~DESC
    Verifies a phone number or an email address with a one-time code, over SMS, WhatsApp, email or
    Telegram, with the channel chosen by your account routing. Ships a drop-in screen and a headless
    core for apps that want their own.
  DESC
  s.homepage          = 'https://otp.com?utm_source=github-sdk-ios'
  s.documentation_url = 'https://github.com/otp-com/sdk-ios'
  s.author            = { 'otp.com' => 'info@otp.com' }
  # :text rather than :file: the published source is the xcframework zip, which carries no LICENSE,
  # and CocoaPods resolves :file against the downloaded pod root.
  s.license           = { :type => 'Commercial', :text => <<~LICENSE }
    Copyright (c) 2026 otp.com. All rights reserved.

    This software is distributed as a compiled binary for use with the otp.com service. Anyone with an
    otp.com account may install it and distribute it as an integral part of their own application,
    subject to the otp.com Terms of Service at https://otp.com/terms-of-service. No other rights are
    granted.

    It may not be distributed on its own, republished, sold, sublicensed, or rented. It may not be
    modified, decompiled, disassembled, or otherwise reverse engineered, and it may not be used
    independently of the otp.com service.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL otp.com BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY ARISING FROM, OUT OF OR
    IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  LICENSE

  s.platform          = :ios, '15.0'
  s.swift_version     = '6.0'

  # The artifact is fetched from the release rather than stored in the repository. A binary committed
  # per version would stay in the clone forever, and CocoaPods reads a zip perfectly well.
  s.source            = {
    :http => "https://github.com/otp-com/sdk-ios/releases/download/#{s.version}/Otp.xcframework.zip"
  }
  s.vendored_frameworks = 'Otp.xcframework'
end
