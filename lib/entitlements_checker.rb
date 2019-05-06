class EntitlementsChecker
  def self.run
    Thread.new { check_entitlements }
  end

  def self.force_degrade
    api = Service.find_by(:name => "Entitlements")
    api.status = ServiceStatus.find(4)
    api.save!
  end

  def self.check_entitlements
    loop do
      begin
        Rails.logger.info "Checking Entitlements"
        code = lookup
        api = Service.find_by(:name => "Entitlements")
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
    url = "https://ci.cloud.paas.upshift.redhat.com/api/entitlements/v1/services"
    rest_return = RestClient::Request.execute(:method => :get,
                                              :url    => url,
                                              :user   => '',
                                              :password => '',
                                              :headers  => {:accept => :json},
                                              :verify_ssl => false)
    Rails.logger.info "REST Return: #{rest_return.code}"
    rest_return.code
  end
end
