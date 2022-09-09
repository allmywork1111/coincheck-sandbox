class HomesController < ApplicationController
  def index
    balance = CoincheckAccountBalance.fetch
    p balance
    # now = Time.current
    # CoincheckTrade.fetch(
    #   from: now.ago(4.year),
    #   to: now.ago(3.years),
    # )
  end
end
