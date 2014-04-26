require "kramdown"
require "nokogiri"

class AreScheduler
  def initialize(markdown="README.md")
    @document = Kramdown::Document.new File.read markdown
    @html = @document.to_html
    @dom = Nokogiri.parse "<body>#{@html}</body>"
  end

  def schedule_table
    @schedule_table ||= @document.root.children.select{|elm| elm.type == :table }.first
  end


  def decided_date
    reg = Regexp.new '日程\s*[:：]\s*(\d+/\d+)'
    unless li = @dom.xpath('//li').find{|i| i.text =~ reg}
      return
    end
    li.text.scan(reg)[0][0]
  end

  def decided_place
    reg = Regexp.new '場所\s*[:：]\s*(.+)'
    unless li = @dom.xpath('//li').find{|i| i.text =~ reg}
      return
    end
    li.text.scan(reg)[0][0]
  end


  def candidates
    @candidates ||= schedule_table.children.select{|e|
      e.type == :thead
    }.first.children[0].children.map{|i|
      i.children[0]
    }.compact.map(&:value)
  end

  def entrants
    header = nil

    @document.root.children.each do |elm|
      header = elm if elm.type == :header && elm.children.first.value == '参加'
      if header && elm.type == :ul
        return elm.children.map{|e| e.children.first.children.first.value.gsub(/^@([a-zA-Z0-9]+).*$/){$1}}
      end
    end

    nil
  end

  def attendants
    tbody = schedule_table.children.select{|e|e.type==:tbody}.first
    tbody.children.select{|row|
      # 名前を除いたカラムを取り出し、さらにその中から空欄になっているカラムを取り出している
      row.children[1..-1].select{|cell| cell.children.length == 0}.length == 0
    }.map{|row|
      name = row.children.first.children.first.value
      _candidates = row.children[1..-1].map{|cell| /[\u25CB\u25EF]/ === cell.children.first.value}
      _candidates = candidates.values_at *_candidates.each_with_index.map{|a,i| a ? i : nil}.compact

      {name => _candidates}
    }
  end

  def names_in_table
    attendants.map(&:keys).flatten
  end

  def place_candidates
    header = nil
    @document.root.children.each do |elm|
      header = elm if elm.type == :header && elm.children.first.value == '場所候補'
      if header && elm.type == :ul
        return elm.children
      end
    end
    nil
  end

  def attend_rates
    result = attendants.each_with_object(Hash.new(0)){|attendant, res|
      attendant.values.flatten.each{|c|
        res[c] += 1
      }
    }

    attend_count = entrants.count

    Hash[result.map{|date, count| [date, Rational(count, attend_count).to_f]}]
  end

  def attendances_on_date date
    attendants.select{|e| e.values.flatten.include? date }.map{|e| e.keys.first}
  end

  def only_in_entrants
    entrants - names_in_table
  end

  def only_in_schedule_table
    names_in_table - entrants
  end
end

def are_scheduler
  @are_scheduler ||= AreScheduler.new
end
