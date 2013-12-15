require 'spec_helper'

describe GamificationObserver do

  let(:author) { create(:user) }
  let(:current_user) {create(:user)}
  let(:group) {create(:topic_group)}
  let(:question) { create(:question, group_id: group.id, author: author) }
  before(:each) do
    author.score = 0
    question.rating = 0
  end

  context 'upvote a post' do
    it "should add 5 points to the users reputation" do
      author.score.should eq(0)
      question.upvote(current_user)
      author.score.should eq(5)
    end

    it 'should increase voting value of question by 1' do
      question.rating.should eq(0)
      question.upvote(current_user)
      question.update_rating
      question.rating.should eq(1)
    end
  end

  context 'downvote a post' do
    it "should remove 5 points from the users reputation and decrease the reputation of the current_user by 1" do
      author.score.should eq(0)
      current_user.score.should eq(0)
      question.downvote(current_user)
      author.score.should eq(-5)
      current_user.score.should eq(-1)
    end

    it 'should decrease voting value of question by 1' do
      question.rating.should eq(0)
      question.downvote(current_user)
      question.update_rating
      question.rating.should eq(-1)
    end
  end 
end
