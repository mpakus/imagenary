require 'spec_helper'

describe "about/index.html.erb" do
  it 'should have about' do
    render
    expect(rendered).to have_content('About')
  end
end
