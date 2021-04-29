# frozen_string_literal: true

class Person
  include Bank

  attr_reader :hand

  def initialize
    @hand = Hand.new
  end
end
