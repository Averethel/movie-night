require 'spec_helper'

describe Ability do
  context "when not logged in" do
    subject { Ability.new(nil) }

    it "can index home" do
      subject.can?(:index, :home).should be_true
    end

    it "cannot index movies" do
      subject.can?(:index, Movie).should be_false
    end

    it "cannot new movies" do
      subject.can?(:new, Movie).should be_false
    end

    it "cannot create movies" do
      subject.can?(:create, Movie).should be_false
    end
  end

  context "when not logged in" do
    subject { Ability.new(build(:user)) }

    it "can index home" do
      subject.can?(:index, :home).should be_true
    end

    it "can index movies" do
      subject.can?(:index, Movie).should be_true
    end

    it "can new movies" do
      subject.can?(:new, Movie).should be_true
    end

    it "can create movies" do
      subject.can?(:create, Movie).should be_true
    end
  end
end
