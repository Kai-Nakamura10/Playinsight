class QuestionAttempt < ApplicationRecord
  belongs_to :question
  belongs_to :choice
end
