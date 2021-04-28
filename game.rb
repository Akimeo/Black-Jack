# frozen_string_literal: true

class Game
  include Bank

  attr_reader :player, :dealer, :deck
  attr_accessor :game_status, :round_status

  INITIAL_CASH = 100
  BID_AMOUNT = 10
  DEALER_SCORE = 17

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
    player.hand.cards
  end

  def dealer_hand
    dealer.hand.cards
  end

  def player_score
    player.hand.score
  end

  def dealer_score
    dealer.hand.score
  end

  def can_draw?
    !player.hand.enough_cards?
  end

  def dealer_won?
    player.bank.zero?
  end

  def player_won?
    dealer.bank.zero?
  end

  def start_game
    player.bank = INITIAL_CASH
    dealer.bank = INITIAL_CASH
    self.bank = 0
    self.game_status = true
  end

  def start_round
    player.hand.discard
    dealer.hand.discard
    deck.shuffle
    2.times do
      player.hand.draw(deck.top_card)
      dealer.hand.draw(deck.top_card)
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
      player.hand.draw(deck.top_card)
      dealer_turn
      finish_round if player.hand.enough_cards? && dealer.hand.enough_cards?
    when 3
      finish_round
    end
  end

  def dealer_turn
    dealer.hand.draw(deck.top_card) if dealer.hand.score < DEALER_SCORE &&
                                       !dealer.hand.enough_cards?
  end

  def finish_round
    if player.hand.score == dealer.hand.score ||
       player.hand.score > 21 && dealer.hand.score > 21
      player.get_cash(send_cash(BID_AMOUNT))
      dealer.get_cash(send_cash(BID_AMOUNT))
      result = :tie
    elsif player.hand.score > dealer.hand.score && player.hand.score <= 21 ||
          dealer.hand.score > 21
      player.get_cash(send_cash(BID_AMOUNT * 2))
      result = :victory
    else
      dealer.get_cash(send_cash(BID_AMOUNT * 2))
      result = :defeat
    end
    self.round_status = false
    self.game_status = false if dealer_won? || player_won?
    result
  end
end
