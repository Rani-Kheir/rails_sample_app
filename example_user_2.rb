class User
  attr_accessor :first, :last

  def initialize(attributes = {})
    @first  = attributes[:first]
    @last = attributes[:last]
  end

  def full_name
    "#{first} #{last}"
  end

  def alphabetical_name
    "#{last}, #{first}"
  end
end
