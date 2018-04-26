class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount   = amount
    @currency = currency
  end

  def inspect
    "#{"%0.2f" % @amount} #{@currency}"
  end

  def self.configure
  end
end

Money.configure do |config|
  config.default_currency = "EUR"
  config.conversions = {
    'USD' => 1.11,
    'Bitcoin' => 0.0047
  }
end

test "Instance a new money obj" do
  fifty_eur = Money.new(50, 'EUR')

  assert 50          == fifty_eur.amount
  assert 'EUR'       == fifty_eur.currency
  assert "50.00 EUR" == fifty_eur.inspect
end

