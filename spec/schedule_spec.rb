require "spec_helper"

describe "アレ会のスケジュール" do
  subject { schedule_table }
  it "should 全員参加可能な日がある" do
    max_attendance_date = attend_rates(schedule_table)
    .sort { |a, b| b[1] <=> a[1] }
    .first

    expect(max_attendance_date[1]).to be(1.0),
                                      "最高に出られる日は#{max_attendance_date[0]}で、"\
                                      "#{max_attendance_date[1] * 100}%出れる。"
  end
end
