FactoryGirl.define do
  factory :question, class: Post do
    type "question"
    subject "Panic!"
    course
  end

  factory :answer, class: Post do
    type "answer"
    subject "No Panic ;-)"
    course
  end

  # TODO factory for news item

  factory :question_with_answer, parent: :question do
    after_create do |question|
      create :answer, parent: question
    end
  end
end
