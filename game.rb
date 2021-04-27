# frozen_string_literal: true

class Game
  include Bank

  attr_reader :player, :dealer, :deck
  attr_accessor :game_status, :round_status

  INITIAL_CASH = 100
  BID_AMOUNT = 10
  DEALER_SCORE = 17
  CARD_VALUE = { n2: 2, n3: 3, n4: 4, n5: 5, n6: 6, n7: 7, n8: 8, n9: 9,
                 n10: 10, j: 10, q: 10, k: 10, a: 11 }.freeze

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @game_status = false
    @round_status = false
  end

  def player_bank
    player.bank
  end

  def dealer_bank
    dealer.bank
  end

  def player_hand
    player.hand
  end

  def dealer_hand
    dealer.hand
  end

  def player_score
    score(player)
  end

  def dealer_score
    score(dealer)
  end

  def can_draw?
    player.card_quantity == 2
  end

  def player_won?
    dealer_bank.zero?
  end

  def score(person)
    score = 0
    aces = 0
    person.hand.each do |card|
      aces += 1 if card.type == :a
      score += CARD_VALUE[card.type]
    end
    while score > 21 && aces != 0
      score -= 10
      aces -= 1
    end
    score
  end

  def enough_cards?
    return true if player.card_quantity == 3 && dealer.card_quantity == 3

    false
  end

  def start_game
    player.bank = INITIAL_CASH
    dealer.bank = INITIAL_CASH
    self.bank = 0
    self.game_status = true
  end

  def start_round
    player.discard
    dealer.discard
    deck.shuffle
    2.times do
      player.draw(deck.top_card)
      dealer.draw(deck.top_card)
    end
    get_cash(player.send_cash(BID_AMOUNT))
    get_cash(dealer.send_cash(BID_AMOUNT))
    self.round_status = true
  end

  def player_turn(action)
    case action
    when 1
      dealer_turn
    when 2
      player.draw(deck.top_card)
      dealer_turn
      finish_round if enough_cards?
    when 3
      finish_round
    end
  end

  def dealer_turn
    dealer.draw(deck.top_card) if score(dealer) < DEALER_SCORE &&
                                  dealer.card_quantity == 2
  end

  def finish_round
    if score(player) == score(dealer) || score(player) > 21 && score(dealer) > 21
      player.get_cash(send_cash(BID_AMOUNT))
      dealer.get_cash(send_cash(BID_AMOUNT))
      result = :tie
    elsif score(player) > score(dealer) && score(player) <= 21 || score(dealer) > 21
      player.get_cash(send_cash(BID_AMOUNT * 2))
      result = :victory
    else
      dealer.get_cash(send_cash(BID_AMOUNT * 2))
      result = :defeat
    end
    self.round_status = false
    self.game_status = false if dealer.bank.zero? || player.bank.zero?
    result
  end
end
