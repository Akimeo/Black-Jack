# frozen_string_literal: true

class Interface
  PRINT_TYPES = { n2: '2 ', n3: '3 ', n4: '4 ', n5: '5 ', n6: '6 ', n7: '7 ',
                  n8: '8 ', n9: '9 ', n10: '10', j: 'J ', q: 'Q ', k: 'K ',
                  a: 'A ' }.freeze
  PRINT_SUITS = { clubs: '♠', diamonds: '♦', hearts: '♥', spades: '♣' }.freeze

  def greeting
    puts 'Для начала представтесь:'
    @name = gets.chomp
    puts "\nДобро пожаловать в игру Black Jack, #{name}! Ваша задача " \
         "обыграть дилера, забрав его банк себе. Для победы в раунде " \
         "получите больше очков чем оппонент, но не более 21."
    @game = Game.new
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

# Доработать завершение игры
  def game_cycle
    game.start_round
    puts "\nСтавки сделаны, раунд начался!"
    while game.round_status
      show_table
      print_options
      input = gets.chomp.to_i
      temp = game.player_turn(input)
    end
    show_table(false)
    puts "Сумма очков дилера: #{game.dealer_score}"
    puts temp
    print_bank
    puts "Играем дальше?\n1. Да\n2. Нет"
    input = gets.chomp.to_i
    game_cycle if input == 1
  end

  def print_bank
    puts "В банке игрока #{game.player_bank}$"
    puts "В банке дилера #{game.dealer_bank}$"
  end

  def show_table(hide = true)
    puts "\n=================="
    print_cards(game.dealer_hand, hide)
    print_cards(game.player_hand)
    puts '=================='
    puts "Сумма очков игрока: #{game.player_score}"
  end

  def print_cards(cards, hide = false)
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

# Доработать выбор
  def print_options
    puts "\nВаши действия:"
    if game.can_draw?
      puts "1. Пропустить\n2. Добавить карту \n3. Открыть карты"
    else
      puts "1. Пропустить\n3. Открыть карты"
    end
  end
end
