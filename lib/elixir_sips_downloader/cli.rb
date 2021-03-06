require 'thor'
require 'user-configurations'

require_relative '../elixir-sips-downloader'

# The Command Line Interface for Elixir Sips Downloader.
class ElixirSipsDownloader::CLI < Thor
  # Long description for download action
  def self.download_long_description
    env_vars = ElixirSipsDownloader::Config::CONFIG_KEYS.join(',')
    <<-LONG_DESC
To download, you need to be authenticated. You have three options:

- Pass the params described before

- Use `elixir-sips-downloader configure`

- Pass/export env vars: #{ env_vars }
    LONG_DESC
  end

  # Perform complete download procedure.
  desc 'download', 'Download new content'
  option(
    :email, required: true, default: ElixirSipsDownloader::Config.default_email, aliases: '-e'
  )
  option(
    :password,
    required: true,
    default: ElixirSipsDownloader::Config.default_password,
    aliases: '-p'
  )
  option(
    :download_path,
    required: true,
    default: ElixirSipsDownloader::Config.default_download_path,
    aliases: '-d'
  )
  option(
    :verbose,
    type: :boolean,
    required: false,
    default: false
  )
  long_desc download_long_description
  def download
    set_log_level
    create_agent
    login
    fetch_feed
    create_catalog
    download_catalog
  end

  # Configure user preferences
  desc 'configure -e foo@bar.com -p 123 -d .', 'Configure user preferences'
  option :email,         required: true, aliases: '-e'
  option :password,      required: true, aliases: '-p'
  option :download_path, required: true, aliases: '-d'
  def configure
    ElixirSipsDownloader::Config.update(
      email: email, password: password, download_path: download_path
    )
  end

  private

  def email
    options[:email]
  end

  def password
    options[:password]
  end

  def download_path
    options[:download_path]
  end

  def create_agent
    @agent = Mechanize.new
  end

  def set_log_level
    ElixirSipsDownloader.logger.level = Logger::DEBUG if options[:verbose]
  end

  def login
    ElixirSipsDownloader::Login.new(agent, email, password).login
  end

  def fetch_feed
    @feed = ElixirSipsDownloader::FeedFetcher.new(agent, email, password).fetch
  end

  def create_catalog
    @catalog = ElixirSipsDownloader::Extractors::Catalog.new.extract feed
  end

  def download_catalog
    @catalog.download download_path, agent
  end

  attr_accessor :agent, :feed
end
