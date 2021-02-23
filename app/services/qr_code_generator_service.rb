require 'rqrcode'

def gen_qr_code(content, user_email)
  code = ROTP::TOTP.new(content, issuer: 'Punchclock').provisioning_uri(user_email)
  qrcode = RQRCode::QRCode.new(code)

  png = qrcode.as_png(
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
  )
end