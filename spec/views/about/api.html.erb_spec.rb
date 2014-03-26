require 'spec_helper'

describe "about/api.html.erb" do
  it "should have menu content" do
    render
    expect(rendered).to have_content('Authentication')
    expect(rendered).to have_content('Upload photo')
    expect(rendered).to have_content('Photos feed')
  end
end
