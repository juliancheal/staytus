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

class Webhook::Received < ActiveRecord::Base
end
