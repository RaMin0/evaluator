require 'rails_helper'

RSpec.describe TeamJob, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :user }

  it 'has a valid factory' do
    team_job = FactoryGirl.build(:team_job)
    expect(team_job).to be_valid
  end
  
  it 'validates data existance' do
    team_job = FactoryGirl.build(:team_job)
    team_job.data = ''
    expect(team_job).to_not be_valid
  end
end
