class CoincheckClient
  BASE_URL = "https://coincheck.com/api"

  def initialize
    @conn = Faraday.new(
      url: BASE_URL,
    )
  end

  def rate(pair)
    get(
      path: "rate/#{pair}",
    )
  end

  def account_balance
    path = "accounts/balance"
    get(
      path: path,
      headers: get_auth_headers(path)
    )
  end

  private

  def get(path:, headers: nil)
    response = @conn.get(
      path,
      headers,
    )
    extra_response_body(
      response: response,
    )
  end

  def get_auth_headers(path)
    key = ENV["COINCHECK_API_KEY"]
    secret = ENV["COINCHECK_API_SECRET"]
    binding.b
    nonce = Time.now.to_i.to_s
    message = nonce + "#{BASE_URL}/#{path}"

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
