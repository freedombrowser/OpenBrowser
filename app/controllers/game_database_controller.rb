class GameDatabaseController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    fetch_data


    @titles = []
    @descriptions = []
    @iframes = []
    @links = []

    @data.each do |i|
      @titles << i[0]
      @links << "/database/#{i[0]}"
      @descriptions << i[1]['description']
      iframe = (i[1]['iframe'] rescue 'about:blank').to_s

      @iframes << (iframe.start_with?('http') ? iframe : "https://freedombrowser.org#{iframe}")
    end
  end

  def content
    fetch_data

    @title = params[:content]

    @iframe = @data.fetch(@title, {}).fetch("iframe", nil)

    unless @iframe == nil
      unless @iframe.start_with?('http')
        @iframe = "https://freedombrowser.org#{@iframe}"
      end
    end

    @website_link = @data.fetch(@title, {}).fetch("url", nil)
    @description = @data.fetch(@title, {}).fetch("description", nil)

    @keywords = @data.fetch(@title, {}).fetch("keywords", nil)

  end

  private

  def fetch_data
    freedombrowser_url = 'https://freedombrowser.org'
    sitemap = "#{freedombrowser_url}/static/sitemap.json"
    uri = URI(sitemap)
    response = Net::HTTP.get(uri)
    @data = JSON.parse(response)
  end
end
