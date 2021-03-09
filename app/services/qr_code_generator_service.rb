require 'rqrcode'

class QrCodeGeneratorService
  ISSUER_NAME = 'Punchclock'.freeze
  DEFAULT_PNG_SETTINGS = {
    bit_depth: 1,
    border_modules: 4,
    color_mode: ChunkyPNG::COLOR_GRAYSCALE,
    color: 'black',
    file: nil,
    fill: 'white',
    module_px_size: 6,
    resize_exactly_to: false,
    resize_gte_to: false,
    size: 120
  }

  def self.call(user)
    label = "#{ISSUER_NAME}:#{user.email}"
    otp_url = user.otp_provisioning_uri(label, issuer: ISSUER_NAME)

    RQRCode::QRCode.new(otp_url)
      .as_png(DEFAULT_PNG_SETTINGS)
      .to_data_url
  end
end