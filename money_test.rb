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
    ( amount * self.class.config.conversions[currency] ).round(2)
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
  assert 55.50 == fifty_eur.convert_to('USD')
end
