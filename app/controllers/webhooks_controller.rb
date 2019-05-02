class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    if request.headers['Content-Type'] == 'application/json'
      params = JSON.parse(request.body.read)
    end
    # Webhook::Received.save(data: data, integration: params[:integration_name])

    # param :title, :required => true, :type => String
    # param :initial_update, :required => false, :type => String
    # param :state, :required => false, :type => String
    # param :services, :required => true, :type => Array
    # param :status, :required => true, :type => String
    # param :notify, :required => false
    #
    # action do
    issue_params = {
      title: params["title"],
      initial_update: params["message"],
      initial_update_graph: params["imageUrl"],
      state: "investigating",#params.state,
      service_ids: 4,#Service.where(permalink: params.services).pluck(4),
      service_status_id: 2,#ServiceStatus.where(permalink: params["state"]).first.id,
      notify: false #params.notify
    }
    puts "YOLO params #{issue_params.inspect}"
    issue = Issue.new issue_params
    # puts "YOLO #{issue.inspect}"
    if issue.save
      # structure issue, :full => true
    else
      puts issue.inspect
      error :validation_error, issue.errors
    end

    render nothing: true
  end
end

# {
#   "title": "My alert",
#   "ruleId": 1,
#   "ruleName": "Load peaking!",
#   "ruleUrl": "http://url.to.grafana/db/dashboard/my_dashboard?panelId=2",
#   "state": "alerting",
#   "imageUrl": "http://s3.image.url",
#   "message": "Load is peaking. Make sure the traffic is real and spin up more webfronts",
#   "evalMatches": [
#     {
#       "metric": "requests",
#       "tags": {},
#       "value": 122
#     }
#   ]
# }
