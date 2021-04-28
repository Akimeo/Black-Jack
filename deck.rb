# frozen_string_literal: true

class Deck
  def initialize
    @deck = []
  end

  def shuffle
    deck.clear
    Card::TYPES.each do |type|
      Card::SUITS.each { |suit| deck.push(Card.new(type, suit)) }
    end
    deck.shuffle!
  end

  def top_card
    deck.pop
  end

  private

  attr_reader :deck
end
