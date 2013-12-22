require 'spec_helper'

describe "Requests to /users/auth.json" do
  let(:valid_user){ build(:user) }
  let(:invalid_user){ build(:user, password: '100600') }

  before :each do
    @user = create(:user)
  end

  it "is authenticate right user" do
    post( auth_users_path(format: :json), {email: valid_user.email, password: valid_user.password})

    expect(response).to be_success
    expect(response.body.blank?).to_not be_true
    json = JSON.parse(response.body)
    expect(json['user']['token']).to eq(@user.token)
  end

  it "is drop authentication error for invalid user" do
    post( auth_users_path(format: :json), {email: invalid_user.email, password: invalid_user.password})

    expect(response).to be_success
    expect(response.body.blank?).to_not be_true
    json = JSON.parse(response.body)
    expect(json['status']['code']).to_not eq(200)
  end

end