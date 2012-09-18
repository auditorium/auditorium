class Term < ActiveRecord::Base
  has_many :courses
  attr_accessible :term_type, :beginDate, :endDate

  validates :term_type,  presence: true,
                    inclusion: { in: %w{ss ws tri1 tri2 tri3} }
  validates :beginDate, presence: true
  validates :endDate,   presence: true


  def code 
    name = term_type.upcase
    if term_type == 'ss'
      return "#{name} #{endDate.year.to_s[2,4]}"
    else
      return "#{name} #{beginDate.year.to_s[2,4]}/#{endDate.year.to_s[2,4]}"
    end
  end

  def to_s
    self.code
  end

  def is_now?
    self.beginDate <= Date.today and  Date.today <= self.endDate
  end

  def current
    Term.order(:name).select {|term| term.is_now? }
  end
end
