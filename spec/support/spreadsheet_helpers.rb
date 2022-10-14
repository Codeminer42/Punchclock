RSpec.shared_examples 'a valid spreadsheet' do
  it 'do not raise error' do
    expect{ Roo::Excelx.new('/tmp/spreadsheet_temp.xlsx') }.to_not raise_error
  end
end

RSpec.shared_examples 'a spreadsheet with header and body' do
  let(:header_row) { 1 }
  let(:body_row) { 2 }
  let(:worksheet) do
    Roo::Spreadsheet.open('/tmp/spreadsheet_temp.xlsx').sheet(0)
  end

  it 'has header' do
    expect(worksheet.row(header_row)).to eq(header_attributes)
  end

  it 'has body' do
    expect(worksheet.row(body_row)).to eq(body_attributes)
  end
end
