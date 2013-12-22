require 'spec_helper'

describe "Requests to /photos.json" do
  let(:invalid_user){ build(:user, email: nil) }

  before :each do
    @user = create(:user)
    @file = fixture_file_upload("#{Rails.root}/spec/fixtures/files/image.jpg", 'image/jpeg')
  end

  it "with right token it's upload file" do
    post( photos_path(format: :json), {token: @user.token, photo: @file})

    expect(response).to be_success
    expect(response.body.blank?).to_not be_true
    json = JSON.parse(response.body)
    expect(json['status']['code']).to eq(200)
    expect(json['photo']['id']).to be_present
    expect(json['photo']['image']['thumb']).to be_present
    expect(json['photo']['image']['full']).to be_present
  end

  it "with wrong token it's finish with 404 error" do
    post( photos_path(format: :json), {token: 'IMGRY_WRONG_TOKEN', photo: @file})

    expect(response).to be_success
    expect(response.body.blank?).to_not be_true
    json = JSON.parse(response.body)
    expect(json['status']['code']).to eq(404)
  end

  it "with right token but empty file it's finish with 500 error" do
    post( photos_path(format: :json), {token: @user.token, photo: nil})

    expect(response).to be_success
    expect(response.body.blank?).to_not be_true
    json = JSON.parse(response.body)
    expect(json['status']['code']).to eq(500)
  end

end