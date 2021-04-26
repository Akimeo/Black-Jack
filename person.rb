# frozen_string_literal: true

class Person
  include Bank

  attr_accessor :hand

  def initialize
    @hand = []
  end

  def discard
    hand.clear
  end

  def draw(card)
    hand.push(card)
  end

  def card_quantity
    hand.size
  end
end
