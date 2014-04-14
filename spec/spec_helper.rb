require "kramdown"

def schedule_table
  src = File.read("README.md")
  Kramdown::Document.new(src).root.children.select do |elm|
    elm.type == :table
  end.first
end

def check(table)
  exist_a_day_which_all_attendees_can_attend_arekai = false
  rows = table.children.select { |e| e.type == :tbody }.first.children
  rows.first.children.size.times do |column|
    can_all_arekai_attendees_attend_this_date = true
    if column > 0
      rows.each do |row|
        if row.children[column].children
          if row.children[column].children.size == 0 ||
             !!!row.children[column].children.first.value.match(/[\u25CB\u25EF]/)
            can_all_arekai_attendees_attend_this_date = false
          end
        end
      end
      if can_all_arekai_attendees_attend_this_date
        exist_a_day_which_all_attendees_can_attend_arekai = true
      end
    end
  end
  exist_a_day_which_all_attendees_can_attend_arekai
end
