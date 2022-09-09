class CoincheckClient
  BASE_URL = "https://coincheck.com/api"

  def initialize
    @conn = Faraday.new(
      url: BASE_URL,
    )
  end

  def trades(pair:, pagination: nil)
    path = "trades"
    params = {
      pair: pair,
    }

    if pagination.present?
      params.merge!(pagination)
    end

    request_for_get(
      path: path,
      params: params,
    )
  end

  def rate(pair)
    path = "rate/#{pair}"
    request_for_get(
      path: path,
    )
  end

  def account_balance
    path = "accounts/balance"
    request_for_get(
      path: path,
      headers: get_auth_headers(path)
    )
  end

  def exchange_order(pair:, order_type:, rate:, amount:)
    path = "exchange/orders"
    params = {
      pair: pair,
      order_type: order_type,
      rate: rate,
      amount: amount,
    }
    request_for_post(
      path: path,
      params: params,
      headers: get_auth_headers(path, params)
    )
  end

  private

  def request_for_get(path:, params: nil, headers: nil)
    response = @conn.get(path, params, headers)
    extra_response_body(
      response: response,
    )
  end

  def request_for_post(path:, params:, headers:)
    response = @conn.post(path, params, headers)
    extra_response_body(
      response: response,
    )
  end

  def get_auth_headers(path, params = nil)
    key = ENV["COINCHECK_API_KEY"]
    secret = ENV["COINCHECK_API_SECRET"]

    nonce = Time.current.to_i.to_s
    message = nonce + "#{BASE_URL}/#{path}" + params.to_param

    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, message)
    {
      "ACCESS-KEY" => key,
      "ACCESS-NONCE" => nonce,
      "ACCESS-SIGNATURE" => signature
    }
  end

  def extra_response_body(response:)
    parsed_body = JSON.parse(response.body)

    if response.status != 200
      raise CoincheckClientError.new(parsed_body["error"])
    end

    parsed_body
  end

  class CoincheckClientError < StandardError
  end
end
