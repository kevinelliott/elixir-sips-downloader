describe ElixirSipsDownloader::Extractor do
  subject(:extractor) { extractor_class.new }

  let(:extractor_class) { Class.new ElixirSipsDownloader::Extractor }

  describe 'contract' do
    specify('#extract') do
      expect { extractor.extract }.to raise_error NotImplementedError
    end
  end
end
