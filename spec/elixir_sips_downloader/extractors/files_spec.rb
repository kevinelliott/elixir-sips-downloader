describe ElixirSipsDownloader::Extractors::Files do
  subject(:files_extractor) do
    ElixirSipsDownloader::Extractors::Files.new
  end

  it 'is an Extractor' do
    expect(files_extractor).to be_a ElixirSipsDownloader::Extractor
  end

  describe '#extract' do
    subject(:extracted_files) { files_extractor.extract item_description }

    let(:item_description) { File.read 'spec/fixtures/feed_description.html' }
    let(:files) do
      Set[
        ElixirSipsDownloader::Downloadables::File.new(
          'some-episode-file.html',
          'http://example.com/some-episode-file.html'),
        ElixirSipsDownloader::Downloadables::File.new(
          'some-episode-file.mp4',
          'http://example.com/some-episode-file.mp4'),
        ElixirSipsDownloader::Downloadables::File.new(
          'some-episode-file.rb',
          'http://example.com/some-episode-file.rb'),
      ]
    end

    it 'returns a Set of Files' do
      expect(extracted_files).to eq(files)
    end

    context 'list of links in description that are not attached files' do
      let(:item_description) do
        File.read('spec/fixtures/feed_description_with_list.html')
      end

      it 'ignores the list' do
        expect(extracted_files).to eq(files)
      end
    end
  end
end
