# frozen_string_literal: true

class Deck
  CARD_TYPES = %i[n2 n3 n4 n5 n6 n7 n8 n9 n10 j q k a].freeze
  CARD_SUITS = %i[clubs diamonds hearts spades].freeze

  def initialize
    @deck = []
  end

  def shuffle
    deck.clear
    CARD_TYPES.each { |type| CARD_SUITS.each { |suit| deck.push(Card.new(type, suit)) } }
    deck.shuffle!
  end

  def top_card
    deck.pop
  end

  private

  attr_reader :deck
end
