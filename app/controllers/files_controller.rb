# app/controllers/files_controller.rb
require 'ptools'
class FilesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  public_directory = Rails.root.join('public/cdn')
  request_path = request.path_info.gsub('/cdn', '')
  full_path = File.join(public_directory, request_path)

  # If the request is for a directory, serve its contents
  if File.directory?(full_path)
    entries = Dir.entries(full_path).reject { |entry| entry == '.' }

    # Separate directories and files
    directories = entries.select { |entry| File.directory?(File.join(full_path, entry)) }.sort
    files = entries.reject { |entry| File.directory?(File.join(full_path, entry)) }.sort

    # Combine directories and files, with directories at the top
    @entries = (directories + files).map do |entry|
      OpenStruct.new(basename: entry, directory?: File.directory?(File.join(full_path, entry)))
    end

    @current_path = request.path_info
    render 'files/index'
  else
    # If the request is for a file, serve the file
    response = Rack::Directory.new(public_directory).call(request.env)
    self.status = response[0]
    self.headers.merge!(response[1])
    self.response_body = response[2]
  end
end


  def file_type(entry_path, full_path)
    if File.directory?(full_path)
      'folder'
    else
      extension = File.extname(entry_path).downcase[1..-1]

      if File.exist?(Rails.root.join('app', 'assets', 'images', 'icons', "#{extension}.png"))
        "#{extension}"
      else
        entry_full_path = Rails.root.join('public', 'files', entry_path)
        entry_full_path = entry_full_path.sub("/files", full_path)
        Rails.logger.debug "entry full path: #{entry_full_path}"
        Rails.logger.debug "full path: #{full_path}"


        # Check if the entry is a directory before calling File.binary?
        if File.directory?(entry_full_path)
          'folder'
        else
          File.binary?(entry_full_path) ? 'binary-file' : 'text-file'
        end
      end
    end
  end
end