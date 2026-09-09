Pod::Spec.new do |s|
  s.name              = 'Otp'
  s.version           = '0.1.0'
  s.summary           = 'Phone and email verification for iOS.'
  s.description       = <<~DESC
    Verifies a phone number or an email address with a one-time code, over SMS, WhatsApp, email or
    Telegram, with the channel chosen by your account routing. Ships a drop-in screen and a headless
    core for apps that want their own.
  DESC
  s.homepage          = 'https://otp.com?utm_source=github-sdk-ios'
  s.documentation_url = 'https://github.com/otp-com/sdk-ios'
  s.author            = { 'otp.com' => 'info@otp.com' }
  s.license           = { :type => 'Commercial', :file => 'LICENSE' }

  s.platform          = :ios, '15.0'
  s.swift_version     = '5.9'

  # The artifact is fetched from the release rather than stored in the repository. A binary committed
  # per version would stay in the clone forever, and CocoaPods reads a zip perfectly well.
  s.source            = {
    :http => "https://github.com/otp-com/sdk-ios/releases/download/#{s.version}/Otp.xcframework.zip"
  }
  s.vendored_frameworks = 'Otp.xcframework'
end
