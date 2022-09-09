class CoincheckAccountBalance
  class << self
    def fetch
      client = CoincheckClient.new
      client.account_balance
    end
  end
end