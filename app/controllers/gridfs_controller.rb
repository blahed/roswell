require 'mongo'

class GridfsController < ApplicationController

    def serve
    gridfs_path = env["PATH_INFO"].gsub("/files/", "")
    begin
      gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(gridfs_path, 'r')
      send_data gridfs_file.read, type: gridfs_file.content_type, filename: gridfs_path.split('/').last, :disposition => 'attachment'
    rescue
      self.status = :file_not_found
      self.content_type = 'text/plain'
      self.response_body = ''
    end
  end

end