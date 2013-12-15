require 'spec_helper'

feature 'Voting' do
  let(:author) { create(:user) }
  let(:current_user) {create(:user)}
  let(:group) {create(:topic_group)}
  let(:question) { create(:question, group_id: group.id, author: author) }
  let(:answer) { create(:answer, author: author) }
  let(:comment) { create(:comment, author: author) }
  background do
    login_with( current_user )
  end

  scenario "user visits question page and upvotes it" do
    question.rating = 0

    puts "ID: #{question.id}"
    visit question_path(question, locale: I18n.locale)
    expect(page).to have_content question.subject
    find('.upvote a').click
    question.reload
    question.rating.should eq(1)
  end

  scenario "user visits question page and downvotes it" do
    question.rating = 0
    visit question_path(question, locale: I18n.locale)
    expect(page).to have_content question.subject
    find('.downvote a').click
    question.reload
    question.rating.should eq(-1)
  end
end