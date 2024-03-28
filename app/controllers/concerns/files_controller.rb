class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file_deleted = false
    if current_user&.author_of?(@file.record)
      @file_deleted = @file.purge
    end
  end
end