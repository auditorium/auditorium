# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  term_type  :string(255)
#  beginDate  :date
#  endDate    :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  jexam_id   :integer          default(0)
#

class Term < ActiveRecord::Base
  has_many :courses
  attr_accessible :term_type, :beginDate, :endDate, :jexam_id

  validates :term_type,  presence: true,
                    inclusion: { in: %w{ss ws tri1 tri2 tri3} }
  validates :beginDate, presence: true
  validates :endDate,   presence: true

  scope :current, -> {where("beginDate < ?", Date.today).where("endDate > ?", Date.today)}

  def code 
      return "#{term_type.upcase} #{short_year}"
  end

  def year
    if endDate.year == beginDate.year
      return "#{endDate.year.to_s}"
    else
      return "#{beginDate.year.to_s}/#{endDate.year.to_s}"
    end
  end

  def short_year
    if endDate.year == beginDate.year
      return "#{endDate.year.to_s[2,4]}"
    else
      return "#{beginDate.year.to_s[2,4]}/#{endDate.year.to_s[2,4]}"
    end
  end

  def type
    self.term_type
  end

  def to_s
    self.code
  end

  def is_now?
    self.beginDate <= Date.today and  Date.today <= self.endDate
  end

  def current
    Term.where('beginDate <= ? and  ? <= endDate', Date.today, Date.today)
  end

  def short_name
    "#{self.term_type.uppercase} #{self.year}"
  end

  def long_name
    if self.term_type.eql? 'ss'
      "Sommersemester #{self.year}"
    else
      "Wintersemester #{self.year}"
    end
  end

end
