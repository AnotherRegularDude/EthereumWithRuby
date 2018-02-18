url = Rails.configuration.x.rpc_client.url

Ethereum::Singleton.instance = Ethereum::HttpClient.new(url)
