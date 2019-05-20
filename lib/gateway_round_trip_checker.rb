class GatewayRoundTripChecker
  def self.run
    Thread.new { check_entitlements }
  end

  def self.degrade
    api = Service.find_by(:name => "Gateway Round-Trip")
    api.status = ServiceStatus.find(4)
    api.save!
  end

  def self.operational
    api = Service.find_by(:name => "Gateway Round-Trip")
    api.status = ServiceStatus.find(1)
    api.save!
  end

  def self.check_entitlements
    loop do
      begin
        Rails.logger.info "Checking Gateway"
        code = lookup
        api = Service.find_by(:name => "Gateway Round-Trip")
        Rails.logger.info "Received: #{code}"
        if code != 200
          apply_code(api, 4)
        else
          apply_code(api, 1)
        end
        sleep(10)
      rescue Exception => e
        Rails.logger.info "Error: #{e.message} Setting to service level 'Major Outage'"
        apply_code(api, 4)
        sleep(10)
      end
    end
  end

  def self.apply_code(api, id)
    if api.status_id != id
      api.status = ServiceStatus.find(id)
      api.save!
      Rails.logger.info "Set status to #{api.status.name}"
    end
  end

  def self.lookup
    begin
      url = "https://ci.cloud.paas.upshift.redhat.com/api/apicast-tests/ping"
      rest_return = RestClient::Request.execute(:method => :get,
                                                :url    => url,
                                                :user   => '',
                                                :password => '',
                                                :headers  => { 'x-rh-insights-gateway-use-auth-cache' => 0, 'x-rh-insights-gateway-use-entitlements-cache' => 0 },
                                                :verify_ssl => false)
      Rails.logger.info "REST Return: #{rest_return.code}"
      rest_return.code
    rescue Exception => e
      Rails.logger.info "Error connecting: #{e.message}"
      500
    end
  end
end
