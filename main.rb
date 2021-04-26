# frozen_string_literal: true

require_relative 'bank'
require_relative 'person'
require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'game'
require_relative 'interface'

interface = Interface.new
interface.greeting
