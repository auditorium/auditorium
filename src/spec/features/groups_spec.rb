require 'spec_helper'

feature 'Manage groups' do
  background do
    Capybara.javascript_driver = :webkit
    login_with(create(:admin))
  end

  scenario "add new group", js: true do
    visit new_group_path
    expect(page).to have_content('Create a new group')
    find('#group_group_type').value.should eq ''
    find('#lecture').click
    find('#group_group_type').value.should eq 'lecture'
  end
end