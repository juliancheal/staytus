require 'rails_helper'

RSpec.describe Issue, :type => :model do
  subject { described_class.new }

  context "Grafana types, JSON received" do
   #
   # before(:each) do
   #   request.headers['Content-Type'] = "application/json"
   # end

   let(:json_file) { "#{Rails.root}/spec/fixtures/webhooks/grafana/alert.json" }
   let(:subject) { post :receive, {integration_name: "grafana"} }

   describe "#receive webhook" do

     it "creates a new Grafana Alert webhook submission" do
       data = JSON.parse(File.read(json_file))
       # expect(Issue).to receive(:save).with(data: data, integration: "grafana").and_return(true)
       expect(subject.name).to eq("My alert")
     end
   end
  end
end
