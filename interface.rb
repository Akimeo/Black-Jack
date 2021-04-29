# frozen_string_literal: true

class Interface
  PRINT_TYPES = { n2: '2 ', n3: '3 ', n4: '4 ', n5: '5 ', n6: '6 ', n7: '7 ',
                  n8: '8 ', n9: '9 ', n10: '10', j: 'J ', q: 'Q ', k: 'K ',
                  a: 'A ' }.freeze
  PRINT_SUITS = { clubs: '♠', diamonds: '♦', hearts: '♥', spades: '♣' }.freeze

  def initialize(game)
    @game = game
  end

  def greeting
    puts 'Для начала представтесь:'
    @name = gets.chomp
    puts "\nДобро пожаловать в игру Black Jack, #{name}! Ваша задача " \
         'обыграть дилера, забрав его банк себе. Для победы в раунде ' \
         'получите больше очков чем оппонент, но не более 21.'
    game_start
  end

  private

  attr_reader :name, :game

  def game_start
    game.start_game
    puts "\nИгра началась!"
    print_bank
    game_cycle
  end

  def game_cycle
    game.start_round
    puts "\nСтавки сделаны, раунд начался!"
    while game.round_status
      show_table
      print_options
      result = game.player_turn(make_choice)
    end
    show_table(hide: false)
    puts "Сумма очков дилера: #{game.dealer_score}"
    case result
    when :tie
      puts "\nРаунд завершился ничьей!"
    when :victory
      puts "\nВ раунде побеждает #{name}!"
    when :defeat
      puts "\nВ раунде побеждает дилер!"
    end
    print_bank
    if game.game_status
      game_cycle
    else
      game_finish
    end
  end

  def game_finish
    puts "\nИгра окончена!"
    if game.player_won?
      puts "#{name} wins!"
    else
      puts 'Dealer wins!'
    end
    puts "\nХотите сыграть еще раз?\n1. Да\n2. Нет"
    input = gets.chomp.to_i
    game_start if input == 1
  end

  def print_bank
    puts "\nВ банке игрока #{game.player_bank}$"
    puts "В банке дилера #{game.dealer_bank}$"
  end

  def show_table(hide: true)
    puts "\n=================="
    print_cards(game.dealer_hand, hide: hide)
    print_cards(game.player_hand)
    puts '=================='
    puts "Сумма очков игрока: #{game.player_score}"
  end

  def print_cards(cards, hide: false)
    #  __   __   __   __   __
    # |J | |Q | |K | |A | |* |
    # | ♠| | ♦| | ♥| | ♣| | *|
    #  ‾‾   ‾‾   ‾‾   ‾‾   ‾‾
    puts '  __  ' * cards.size
    if hide
      puts ' |* | ' * cards.size
      puts ' | *| ' * cards.size
    else
      cards.each { |card| print " |#{PRINT_TYPES[card.type]}| " }
      puts
      cards.each { |card| print " | #{PRINT_SUITS[card.suit]}| " }
      puts
    end
    puts '  ‾‾  ' * cards.size
  end

  def print_options
    puts "\nВаши действия:"
    if game.can_draw?
      puts "1. Пропустить\n2. Добавить карту \n3. Открыть карты"
    else
      puts "1. Пропустить\n2. Открыть карты"
    end
  end

  def make_choice
    input = gets.chomp.to_i
    unless game.can_draw?
      case input
      when 2
        return 3
      when 3
        return 0
      end
    end
    input
  end
end
