# frozen_string_literal: true

class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def discard
    cards.clear
  end

  def draw(card)
    cards.push(card)
  end

  def card_quantity
    cards.size
  end

  def score
    score = 0
    aces = 0
    cards.each do |card|
      aces += 1 if card.type == :a
      score += Card::VALUE[card.type]
    end
    while score > 21 && aces != 0
      score -= 10
      aces -= 1
    end
    score
  end

  def enough_cards?
    return true if card_quantity == 3

    false
  end
end
