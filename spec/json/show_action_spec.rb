require 'spec_helper'

describe SweetActions::JSON::ShowAction do
  let(:show_action) { SweetActions::JSON::ShowAction.new(FakeController.new) }

  let(:path_parameters) { { resource_name: 'Event' } }

  before(:each) do
    allow(show_action).to receive(:path_parameters).and_return(path_parameters)
    allow(show_action).to receive(:authorize?).and_return(false)
  end

  describe '.action' do
    subject { show_action.send(:action) }

    it 'should return a hash' do
      expect(subject).to be_a(Hash)
    end

    it 'should return keys of type and attributes' do
      expect(subject.keys).to eq([:type, :attributes])
    end
  end
end