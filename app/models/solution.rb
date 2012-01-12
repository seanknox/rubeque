class Solution
  include Mongoid::Document
  field :code

  referenced_in :problem
  referenced_in :user

  validate :run_problem
  after_create :update_user_solution_count

  protected

    def run_problem
      # initialize test unit
      require 'test/unit'
      extend Test::Unit::Assertions

      # get our code
      problem_code = problem.code.gsub("__", self.code)

      # run it
      begin
        eval(problem_code)
      rescue Exception => e
        errors.add(:base, "Your solution failed: #{e.message}")
      end
    end

    def update_user_solution_count
      # TODO: find all the solutions and update the user's solution count?
      if updating_user = User.find(self.user_id)
        updating_user.solution_count = user.solution_count ? user.solution_count + 1 : 1
        updating_user.save
      end
    end
end
