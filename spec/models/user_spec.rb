require 'spec_helper'

describe User do
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of :email }

  describe "#full_name" do
    subject { create(:user) }
    its(:full_name){ should == "#{subject.name} #{subject.surname}"}
  end
end
