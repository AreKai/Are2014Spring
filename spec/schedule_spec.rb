require "spec_helper"

describe "アレ会のスケジュール" do
  subject { are_scheduler }
  it "should 全員参加可能な日がある" do
    max_attendance_date = are_scheduler.attend_rates.max_by{|k,v| v}

    expect(max_attendance_date[1]).to be(1.0),
      "最高に出られる日は#{max_attendance_date[0]}で、"\
      "#{max_attendance_date[1] * 100}%出れる。"
  end

  it 'should 参加表明の名前リストとスケジュール表の名前リストが一致してる' do
    expect(are_scheduler.entrants.sort).to eq(are_scheduler.names_in_table.sort),
      "#{are_scheduler.only_in_entrants} は参加表明だけしかしてなくて、"\
      "#{are_scheduler.only_in_schedule_table} はスケジュール表だけ書いてる"
  end

  it 'should 場所候補がたくさんある' do
    expect(are_scheduler.place_candidates).to have_at_least(3).items
  end
end
