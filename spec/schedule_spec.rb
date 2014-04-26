require "spec_helper"

describe "アレ会のスケジュール" do
  subject { are_scheduler }
  it "should 全員参加可能な日がある or 日程が決まっている" do
    max_attendance_date = are_scheduler.attend_rates.max_by{|k,v| v}

    expect(are_scheduler.decided_date || (max_attendance_date[1] == 1.0)).to be_true,
      "最高に出られる日は#{max_attendance_date[0]}で、"\
      "#{max_attendance_date[1] * 100}%出れる。"
  end

  it 'should 日程は4人以上集まれる' do
    date = are_scheduler.decided_date
    expect(date).not_to eq(nil), "日程が決まっていない"
    expect(date && are_scheduler.attendances_on_date(date)).to have_at_least(4).people
  end

  it 'should 参加表明の名前リストとスケジュール表の名前リストが一致してる' do
    expect(are_scheduler.entrants.sort).to eq(are_scheduler.names_in_table.sort),
      "#{are_scheduler.only_in_entrants} は参加表明だけしかしてなくて、"\
      "#{are_scheduler.only_in_schedule_table} はスケジュール表だけ書いてる"
  end

  it 'should 場所候補がたくさんある' do
    expect(are_scheduler.place_candidates).to have_at_least(3).items
  end

  it 'should 場所が決まっている' do
    expect(are_scheduler.decided_place).to be_true
  end
end
