FactoryGirl.define do
  factory :result do
    compiled true
    compiler_stderr "stderr"
    compiler_stdout "stdout"
    success true
    grade 10
    max_grade 30
    test_suite {FactoryGirl.create(:public_suite)}
    project {FactoryGirl.create(:project,
    published: true, course: FactoryGirl.create(:course, published: true))}
    after(:build) do |result|
      if result.submission.nil?
        result.submission = FactoryGirl.create(:submission, project: result.project)
      end
    end
    after(:create) do |result|
      result.team_grade = FactoryGirl.create(:team_grade, result: result,
        project: result.project,
        name: result.submission.submitter.team)
    end
  end

end
