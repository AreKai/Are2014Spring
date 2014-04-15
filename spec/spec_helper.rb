require "kramdown"

def schedule_table
  src = File.read("README.md")
  Kramdown::Document.new(src).root.children.select do |elm|
    elm.type == :table
  end.first
end

def check(table)
  ## extract text in cell
  dates = table.children.select{|e|
    e.type == :thead
  }.first.children[0].children.map{|i|
    i.children[0].value rescue nil
  }

  rows = table.children.select{|e|
    e.type == :tbody
  }.first.children.map{|row|
    row.children.map{|i|
      i.children[0].value.strip rescue nil
    }
  }

  ## flip rows -> cols
  cols = []
  while !rows[0].empty?
    cols.push []
    rows.each do |row|
      cols.last.push row.shift
    end
  end

  ## attendance rate
  attend_rates = cols.map do |col|
    col.count{|i| i =~ /[\u25CB\u25EF]/ }.to_f / col.size
  end

  ## all attendees can attend
  attend_rates.count{|i| i >= 1.0 } > 0
end
