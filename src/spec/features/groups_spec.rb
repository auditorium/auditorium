require 'spec_helper'

feature 'Manage groups' do
  background do
    login_with(create(:admin))
  end

  scenario "change group type" do
    tag = create(:tag)

    visit new_group_path(locale: 'en')
    expect(page).to have_content('Create a new group')

    choose('group_group_type_lecture')
    find("//input[@id='group_group_type_lecture'][@checked]")

    find('#group_title').set 'Group title'
    find('#group_description').set 'Group description'
    find('input#group_tag_tokens', visible: false).set tag.id

    find('[name="commit"]').click

    expect(page).to have_content 'Group title'
    expect(page).to have_content 'Group description'
    expect(page).to have_content 'Lecture Group'
    expect(page).to have_content tag.name
  end

  scenario 'new group with invalid data' do
    visit new_group_path(locale: 'en')

    find('[name="commit"]').click

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Group type can't be blank")
  end

  scenario 'edit group with valid data' do
    group = create(:topic_group)
    visit edit_group_path(group, locale: 'en')

    find('#group_title').value.should eq group.title
    find('#group_description').value.should eq group.description
    find("//input[@id='group_group_type_topic'][@checked]")

    find('#group_title').set 'Another title'
    find('#group_description').set 'Another description'

    find('[name="commit"]').click

    expect(page).to have_content('Another title')
    expect(page).to have_content('Another description')
  end

  scenario 'edit group with invalid data' do
    group = create(:topic_group)
    visit edit_group_path(group, locale: 'en')

    find('#group_title').value.should eq group.title
    find('#group_description').value.should eq group.description
    find("//input[@id='group_group_type_topic'][@checked]")

    find('#group_title').set ''
    find('#group_description').set ''

    find('[name="commit"]').click

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
  end
end

feature 'Interact with group' do 
  background do
    login_with(create(:user))
    @group = create(:topic_group)
    @tag = create(:tag)
  end

  scenario 'ask a question', js: true do
    visit group_path(@group, locale: 'en')

    fill_in 'question_subject', with: 'A new question'
    fill_in 'question_content', with: 'The content of the question'
    find('#question_tag_tokens').set @tag.id

    find('#submit-question').click

    expect(page).to have_content 'A new question'
  end
end