class SendSubmissionService
  def self.perform(submission)
    jdoodle_client = Jdoodle::Client.new(submission)
    points = CalculateTestCasePointsService.perform(jdoodle_client, submission.contest.test_cases)

    submission.update_attributes(points: points)
    submission.contestant.schools.each do |school|
      school.update_attributes(points: school.points + points)
    end
  end
end
