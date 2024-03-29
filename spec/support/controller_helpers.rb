# frozen_string_literal: true

module ControllerHelpers
  def login(user)
    @request.env['devise.mappin'] = Devise.mappings[:user]
    sign_in(user)
  end
end
