class SlackWebhook
  def self.post(payload)
    uri = URI(Figaro.env.slack_webhook)
    req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = payload.to_json
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.request(req)
  end
end