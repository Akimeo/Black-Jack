# frozen_string_literal: true

class Card
  TYPES = %i[n2 n3 n4 n5 n6 n7 n8 n9 n10 j q k a].freeze
  SUITS = %i[clubs diamonds hearts spades].freeze
  VALUE = { n2: 2, n3: 3, n4: 4, n5: 5, n6: 6, n7: 7, n8: 8, n9: 9, n10: 10,
            j: 10, q: 10, k: 10, a: 11 }.freeze

  attr_reader :type, :suit

  def initialize(type, suit)
    @type = type
    @suit = suit
  end
end
