require "kramdown"

def document
  src = File.read("README.md")
  Kramdown::Document.new(src)
end

def schedule_table
  document.root.children.select do |elm|
    elm.type == :table
  end.first
end

def entrants
  header = nil
  document.root.children.each do |elm|
    header = elm if elm.type == :header && elm.children.first.value == '参加'
    if header && elm.type == :ul
      return elm.children.map{|e| e.children.first.children.first.value.gsub(/^@([a-zA-Z0-9]+).*$/){$1}}
    end
  end
  nil
end

def names_in_table
  schedule_table.children.select{|e|e.type==:tbody}.first.children.select{|row|
    # 名前を除いたカラムを取り出し、さらにその中から空欄になっているカラムを取り出している
    row.children[1..-1].select{|cell| cell.children.length == 0}.length == 0
  }.map{|row|
    row.children.first.children.first.value
  }
end

def place_candidates
  header = nil
  document.root.children.each do |elm|
    header = elm if elm.type == :header && elm.children.first.value == '場所候補'
    if header && elm.type == :ul
      return elm.children
    end
  end
  nil
end



def attend_rates(table)
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
  until rows[0].empty?
    cols.push []
    rows.each do |row|
      cols.last.push row.shift
    end
  end

  ## attendance rate
  attendance_rates = cols.map do |col|
    [dates.shift, col.count { |i| i =~ /[\u25CB\u25EF]/ }.to_f / col.size]
  end
  Hash[attendance_rates]
end
