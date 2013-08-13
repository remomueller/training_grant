require 'test_helper'

class RegistrationTest < ActionDispatch::IntegrationTest

  test "a new applicant should be able to sign up" do
    assert_difference('Applicant.count') do
      post "/as", applicant: { first_name: 'First Name', last_name: 'Last Name', email: 'new_applicant@example.com', password: 'password', password_confirmation: 'password' }
    end

    assert_not_nil assigns(:applicant)
    assert_equal 'First Name', assigns(:applicant).first_name
    assert_equal 'Last Name', assigns(:applicant).last_name
    assert_equal 'new_applicant@example.com', assigns(:applicant).email

    assert_redirected_to root_path
  end

end
