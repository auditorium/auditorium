require 'spec_helper'

describe "terms/edit" do
  before(:each) do
    @term = assign(:term, stub_model(Term))
  end

  it "renders the edit term form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => terms_path(@term), :method => "post" do
    end
  end
end
