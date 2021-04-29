# frozen_string_literal: true

module Bank
  attr_accessor :bank

  def get_cash(cash)
    self.bank += cash
  end

  def send_cash(cash)
    self.bank -= cash
    cash
  end
end
