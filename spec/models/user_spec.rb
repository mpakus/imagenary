require 'spec_helper'

describe User do
  it "is valid" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without email" do
    expect(build(:user, email: nil)).to have(1).errors_on(:email)
  end

  it "is invalid with email dublicates" do
    user = create(:user)
    expect(build(:user)).to have(1).errors_on(:email)
  end
end