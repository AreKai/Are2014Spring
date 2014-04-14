require "spec_helper"

describe "アレ会のスケジュール" do
  subject { schedule_table }
  it "should 全員参加可能な日がある" do
    expect(check(schedule_table)).to eq(true)
  end
end
