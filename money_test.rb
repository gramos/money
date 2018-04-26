class Money
  class Config < Struct.new(:default_currency, :conversions)
  end

  class << self
    attr_accessor :config
  end

  def self.configure
    @config = Config.new
    yield(@config)
  end

  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount   = amount
    @currency = currency
  end

  def inspect
    "#{"%0.2f" % @amount} #{@currency}"
  end

  def convert_to(currency)
    if currency == self.class.config.default_currency
      new_amount = ( amount / self.class.config.conversions[ self.currency ] ).round(2)
    else
      new_amount = ( amount * self.class.config.conversions[currency] ).round(2)
    end

    Money.new(new_amount, currency)
  end

  def +(money)
    total = self.amount + ( money.convert_to('EUR') )

    Money.new('EUR', total)
  end

end

Money.configure do |config|
  config.default_currency = "EUR"
  config.conversions = {
    'USD' => 1.11,
    'Bitcoin' => 0.0047
  }
end

test "Money class configuration" do
  convert_hash = {'USD' => 1.11, 'Bitcoin' => 0.0047}
  assert convert_hash == Money.config.conversions
end

test "Instance a new money obj" do
  fifty_eur = Money.new(50, 'EUR')

  assert 50          == fifty_eur.amount
  assert 'EUR'       == fifty_eur.currency
  assert "50.00 EUR" == fifty_eur.inspect
end

test "Money#convert_to" do
  fifty_eur = Money.new(50, 'EUR')
  assert '55.50 USD' == fifty_eur.convert_to('USD').inspect

  assert '50.00 EUR' == fifty_eur.convert_to('USD').convert_to('EUR').inspect
end

# test "Arithmetic operations" do
#   fifty_eur      = Money.new(50, 'EUR')
#   twenty_dollars = Money.new(20, 'USD')

#   assert '68.02 EUR' == ( fifty_eur + twenty_dollars ).inspect
# end
