class HomesController < ApplicationController
  def index
    now = Time.current
    CoincheckTrade.fetch(
      from: now.ago(4.year),
      to: now.ago(3.years),
    )
  end
end
