require 'spec_helper'

describe GamificationObserver do

  let(:author) { create(:user) }
  let(:second_author) { create(:user) }
  let(:current_user) {create(:user)}
  let(:group) {create(:topic_group)}
  let(:question) { create(:question, group_id: group.id, author: author) }
  let(:topic) { create(:topic, group_id: group.id, author: author) }
  let(:announcement) { create(:announcement, group_id: group.id, author: author) }
  let(:comment) { create(:comment, commentable: question, author: author) }
  let(:answer) { create(:answer, question: question, author: second_author)}
  before(:all) do
    load Rails.root + "db/seeds.rb" 
  end

  before(:each) do
    author.score = 0
    question.rating = 0
    author.questions.delete_all
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

  context "earning badges" do
    # ==== LEARNING =====
    it "author earns 'bronze learning' badge when a question gets first upvote" do
      author.questions.size.should eq(0)
      question.upvote(current_user)
      question.update_rating
      expect(author.has_badge?('learning', 'bronze')).to be true
    end

    it "author earns 'silver learning' badge when a question gets first 5 upvotes" do
      author.questions.size.should eq(0)
      5.times { question.upvote(create(:user)) }
      question.update_rating
      expect(author.has_badge?('learning', 'silver')).to be true
    end

    it "author earns 'gold learning' badge when a question gets first 10 upvotes" do
      author.questions.size.should eq(0)
      10.times { question.upvote(create(:user)) }
      question.update_rating
      expect(author.has_badge?('learning', 'gold')).to be true
    end

    # ===== Commenter =====
    it "author earns 'bronze commenter' badge when a comment gets first upvote" do
      author.comments.size.should eq(0)
      comment.upvote(current_user)
      comment.update_rating
      expect(author.has_badge?('commenter', 'bronze')).to be true
    end

    it "author earns 'silver commenter' badge when a comment gets first 10 upvotes" do
      author.comments.size.should eq(0) 
      5.times { comment.upvote(create(:user)) }
      comment.update_rating
      expect(author.has_badge?('commenter', 'silver')).to be true
    end

    it "author earns 'gold commenter' badge when a comment gets first 5 upvotes" do
      author.comments.size.should eq(0)
      10.times { comment.upvote(create(:user)) }
      comment.update_rating
      expect(author.has_badge?('commenter', 'gold')).to be true
    end

    # ===== Cooperative ======

    it "author earns 'bronze cooperative' badge when an answer gets first upvote" do
      second_author.answers.size.should eq(0)
      answer.upvote(create(:user))
      answer.update_rating
      expect(second_author.has_badge?('cooperative', 'bronze')).to be true
    end

    it "author earns 'silver cooperative' badge when an answer gets first 5 upvotes" do
      second_author.answers.size.should eq(0)
      5.times {answer.upvote(create(:user))}
      answer.update_rating
      expect(second_author.has_badge?('cooperative', 'silver')).to be true
    end

    it "author earns 'gold cooperative' badge when an answer gets first 10 upvotes" do
      second_author.answers.size.should eq(0)
      10.times {answer.upvote(create(:user))}
      answer.update_rating
      expect(second_author.has_badge?('cooperative', 'gold')).to be true
    end

    # ===== Significant ======

    it "author earns 'bronze significant' badge when an announcement gets first upvote" do
      author.announcements.size.should eq(0)
      announcement.upvote(create(:user))
      announcement.update_rating
      expect(author.has_badge?('significant', 'bronze')).to be true
    end

    it "author earns 'silver significant' badge when an announcement gets first 5 upvotes" do
      author.announcements.size.should eq(0)
      5.times {announcement.upvote(create(:user))}
      announcement.update_rating
      expect(author.has_badge?('significant', 'silver')).to be true
    end

    it "author earns 'gold significant' badge when an announcement gets first 10 upvotes" do
      author.announcements.size.should eq(0)
      10.times {announcement.upvote(create(:user))}
      announcement.update_rating
      expect(author.has_badge?('significant', 'gold')).to be true
    end

    # ==== Something to say =====
    it "author earns 'bronze something_to_say' badge when a topic gets first upvote" do
      author.topics.size.should eq(0)
      topic.upvote(current_user)
      topic.update_rating
      expect(author.has_badge?('something_to_say', 'bronze')).to be true
    end

    it "author earns 'silver something_to_say' badge when a topic gets first 5 upvotes" do
      author.topics.size.should eq(0)
      5.times { topic.upvote(create(:user)) }
      topic.update_rating
      expect(author.has_badge?('something_to_say', 'silver')).to be true
    end

    it "author earns 'gold something_to_say' badge when a topic gets first 10 upvotes" do
      author.topics.size.should eq(0)
      10.times { topic.upvote(create(:user)) }
      topic.update_rating
      expect(author.has_badge?('something_to_say', 'gold')).to be true
    end


    # # ===== Helpful ======

    # it "author earns 'bronze helpful' badge when first answer were marked as helpful" do
    #   second_author.answers.size.should eq(0)
    #   create(:answer, question: question, answer_to_id: question.id, author: second_author)
    #   second_author.reload
    #   second_author.answers.size.should eq(1)
    #   puts "==== #{second_author.badges.inspect}"
    #   #expect(second_author.has_badge?('helpful', 'bronze')).to be true
    # end


    # it "author earns 'silver helpful' badge when first 5 answers were marked as helpful" do
    #   second_author.answers.size.should eq(0)
    #   5.times { create(:answer, question: question, answer_to_id: question.id, author: second_author) }
    #   second_author.reload
    #   second_author.answers.size.should eq(5)
    #   expect(second_author.has_badge?('helpful', 'silver')).to be true
    # end

    # it "author earns 'gold helpful' badge when first 10 answers were marked as helpful" do
    #   second_author.answers.size.should eq(0)
    #   10.times { create(:answer, question: question, answer_to_id: question.id, author: second_author) }
    #   second_author.reload
    #   second_author.answers.size.should eq(10)
    #   expect(second_author.has_badge?('helpful', 'gold')).to be true
    # end

  end
end
