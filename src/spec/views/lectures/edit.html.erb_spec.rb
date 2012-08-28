require 'spec_helper'

describe "lectures/edit" do
  before(:each) do
    @lecture = assign(:lecture, stub_model(Lecture))
  end

  it "renders the edit lecture form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => lectures_path(@lecture), :method => "post" do
    end
  end
end
