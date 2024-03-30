# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/controllers/answers_controller_spec.rb") }
  let!(:file2) { fixture_file_upload("#{Rails.root}/spec/controllers/questions_controller_spec.rb") }
  let!(:question) { create(:question, user:, files: [file, file2]) }
  let!(:attachment) { question.files.first }

  describe 'DELETE #destroy' do
    context 'when user is the author of the file' do
      before { login user }

      it 'deletes the attachment' do
        expect do
          delete :destroy, params: { id: attachment }, xhr: true
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'returns success status' do
        delete :destroy, params: { id: attachment }, xhr: true
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not the author of the file' do
      before { login other_user }

      it 'does not delete the attachment' do
        expect do
          delete :destroy, params: { id: attachment }, xhr: true
        end.not_to change(ActiveStorage::Attachment, :count)
      end

      it 'responds with forbidden status' do
        delete :destroy, params: { id: attachment }, xhr: true
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
