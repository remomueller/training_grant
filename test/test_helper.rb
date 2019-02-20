# frozen_string_literal: true

require "simplecov"
require "minitest/pride"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Set up ActiveSupport tests.
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Set up ActionController tests.
class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def login(resource)
    @request.env["devise.mapping"] = Devise.mappings[resource]
    sign_in(resource, scope: resource.class.name.downcase.to_sym)
  end
end

# Set up ActionDispatch tests.
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def login(user)
    sign_in_as(user, "1234567890")
  end

  def sign_in_as(user, password)
    user.update password: password, password_confirmation: password
    post new_user_session_url, params: {
      user: { email: user.email, password: password }
    }
    follow_redirect!
    user
  end
end

module Rack
  module Test
    # Allow files to be uploaded in tests.
    class UploadedFile
      attr_reader :tempfile
    end
  end
end

# Add helper method to login user.
class ActionDispatch::SystemTestCase
  def visit_login_as_user(user, screenshot_name = nil)
    password = "PASSword2"
    user.update(password: password, password_confirmation: password)
    visit new_user_session_url
    screenshot(screenshot_name) if screenshot_name.present?
    click_element("[data-object=show-administrator-login]")
    screenshot(screenshot_name) if screenshot_name.present?
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    screenshot(screenshot_name) if screenshot_name.present?
    click_form_submit
  end

  def visit_login_as_applicant(applicant, screenshot_name = nil)
    password = "PASSword2"
    applicant.update(password: password, password_confirmation: password)
    visit new_applicant_session_url
    screenshot(screenshot_name) if screenshot_name.present?
    fill_in "applicant[email]", with: applicant.email
    fill_in "applicant[password]", with: applicant.password
    screenshot(screenshot_name) if screenshot_name.present?
    click_form_submit
  end

  def visit_login_as_preceptor(preceptor, screenshot_name = nil)
    password = "PASSword2"
    preceptor.update(password: password, password_confirmation: password)
    visit new_preceptor_session_url
    screenshot(screenshot_name) if screenshot_name.present?
    fill_in "preceptor[email]", with: preceptor.email
    fill_in "preceptor[password]", with: preceptor.password
    screenshot(screenshot_name) if screenshot_name.present?
    click_form_submit
  end
end
