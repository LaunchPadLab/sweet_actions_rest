require_relative 'fake_request'

class FakeController
  def request
    FakeRequest.new
  end

  def params
    {}
  end
end