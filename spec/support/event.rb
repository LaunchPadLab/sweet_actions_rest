class Event
  def initialize
  end

  def self.all
    []
  end

  def self.find(id)
    self.new
  end

  def save
    true
  end
end