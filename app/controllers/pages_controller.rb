require 'httparty'

class PagesController < ApplicationController
  # Make an environment variable called OPENBROWSER_ADMINS and set it to admin:password
  http_basic_authenticate_with name: ENV['OPENBROWSER_ADMINS'].split(':')[0],
                               password: ENV['OPENBROWSER_ADMINS'].split(':')[1], only: [:report_list]
  skip_before_action :verify_authenticity_token

  def index
    render 'index'
  end

  def log_report
    data = request.body.read
    error_text = data.force_encoding('UTF-8')
    puts "Got report: #{error_text}"
    current_date = Time.now.strftime('%d/%m/%Y %H:%M:%S')
    final = "#{current_date}: #{ERB::Util.html_escape(error_text[0..149])}\n"

    File.open('user_reports.txt', 'a') do |file|
      file.puts(final)
    end

    jsonified = JSON.parse(error_text)
    webhook_url = 'https://discord.com/api/webhooks/1111760468936249444/c99L7UU5ykgmV4KI7Kqwr7UW0JOO-6YoDqM1aSfQQ9z2sKfB_3bgvYUOzdWzlp3FYDiK'

    payload = {
      content: nil,
      embeds: [{
                 description: jsonified['content'],
                 color: 2894892,
                 footer: {
                   text: jsonified['ip']
                 },
                 timestamp: Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%fZ')
               }],
      attachments: []
    }

    json_payload = payload.to_json
    headers = { 'Content-Type' => 'application/json' }

    HTTParty.post(webhook_url, body: json_payload, headers: headers)

    render plain: 'Report sent successfully'
  end

  def report_list
    reversed_lines = File.open('user_reports.txt', 'r').readlines.reverse_each
    @list_items = reversed_lines.map { |line| "<li>#{line.chomp}</li>" }

    render 'report_list'
  end

end
