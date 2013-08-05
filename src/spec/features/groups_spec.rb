require 'spec_helper'

feature 'Manage groups' do
  background do
    login_with(create(:admin))
  end

  scenario "change group type", js: true do
    visit new_group_path
    expect(page).to have_content('Create a new group')

    find('#group_group_type').value.should eq ''
    find('#lecture').click
    find('#group_group_type').value.should eq 'lecture'
  end

  scenario 'new group with valid data' do
    tag = create(:tag)

    visit new_group_path

    find('#group_title').set 'Group title'
    find('#group_description').set 'Group description'
    find('#group_group_type', visible: false).set 'lecture'
    find('input#group_tag_tokens', visible: false).set tag.id

    find('#submit').click

    expect(page).to have_content 'Group title'
    expect(page).to have_content 'Group description'
    expect(page).to have_content tag.name
  end

  scenario 'new group with invalid data' do
    visit new_group_path

    find('#submit').click

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Group type can't be blank")
  end

  scenario 'edit group with valid data' do
    group = create(:topic_group)
    visit edit_group_path(group, locale: 'en')

    find('#group_title').value.should eq group.title
    find('#group_description').value.should eq group.description
    find('#group_group_type').value.should eq 'topic'

    find('#group_title').set 'Another title'
    find('#group_description').set 'Another description'
    find('#group_group_type').set 'lecture'

    find('#submit').click

    expect(page).to have_content('Another title')
    expect(page).to have_content('Another description')
  end

  scenario 'edit group with invalid data' do
    group = create(:topic_group)
    visit edit_group_path(group, locale: 'en')

    find('#group_title').value.should eq group.title
    find('#group_description').value.should eq group.description
    find('#group_group_type').value.should eq 'topic'

    find('#group_title').set ''
    find('#group_description').set ''
    find('#group_group_type').set ''

    find('#submit').click

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Group type can't be blank")
  end

end