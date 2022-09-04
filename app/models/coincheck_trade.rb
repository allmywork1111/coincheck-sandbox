class CoincheckTrade
  class << self
    def fetch(from:, to:)
      client = CoincheckClient.new
      tarde = client.trades(
        pair: "btc_jpy",
        pagination: {
          limit: 100
        }
      )
    end
  end
end
