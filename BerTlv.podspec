Pod::Spec.new do |s|
  s.name             = "BerTlv"
  s.version          = "0.1.4"
  s.summary          = "BER-TLV parser and builder"
  s.description      = <<-DESC
                       Features

                       * Parsing
                       * Easy building
                       DESC
  s.homepage         = "https://github.com/evsinev/BerTlv"
  s.license          = 'APACHE'
  s.author           = { "Evgeniy Sinev" => "es@payneteasy.com" }
  s.source           = { :git => "https://github.com/evsinev/BerTlv.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'BerTlv'
end
