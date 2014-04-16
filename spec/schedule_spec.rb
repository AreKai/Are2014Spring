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

  it 'should 参加表明の名前リストとスケジュール表の名前リストが一致してる' do
    expect(entrants.sort).to eq(names_in_table.sort),
      "#{(entrants - names_in_table)} は参加表明だけしかしてなくて、"\
      "#{(names_in_table - entrants)} はスケジュール表だけ書いてる"
  end

  it 'should 場所候補がたくさんある' do
    expect(place_candidates).to have_at_least(3).items
  end
end
