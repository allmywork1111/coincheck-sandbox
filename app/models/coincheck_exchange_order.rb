class CoincheckExchangeOrder
  class << self
    def buy(rate:, amount:)
      pair = "btc_jpy"
      order_type = "buy"

      client = CoincheckClient.new
      client.exchange_order(
        pair: pair,
        order_type: order_type,
        rate: rate,
        amount: amount,
      )
    end
  end
end
