require 'rails_helper'

RSpec.describe QrCodeGeneratorService do
  let(:user) do
    create(
      :user,
      otp_secret: 'fake_secret',
      email: 'example@exp.com'
    )
  end

  let(:png_image) do
    double('png_image', to_data_url: 'data:fake_image_data')
  end

  let(:qr_code) do
    double('qr_code', as_png: png_image)
  end

  before do
    allow(RQRCode::QRCode)
      .to receive(:new)
      .and_return(qr_code)
  end

  it 'create QR Code with the right URI' do
    image_data = QrCodeGeneratorService.call(user)

    expect(RQRCode::QRCode)
      .to have_received(:new)
      .with('otpauth://totp/Punchclock:Punchclock_example%40exp.com?secret=fake_secret&issuer=Punchclock')

    expect(image_data).to eq('data:fake_image_data')
  end
end
