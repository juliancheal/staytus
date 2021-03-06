# == Schema Information
#
# Table name: sites
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :string
#  domain              :string
#  support_email       :string
#  website_url         :string
#  time_zone           :string
#  crawling_permitted  :boolean          default(FALSE)
#  email_from_name     :string
#  email_from_address  :string
#  allow_subscriptions :boolean          default(TRUE)
#  http_protocol       :string
#  privacy_policy_url  :string
#

class Site < ActiveRecord::Base

  validates :title, :presence => true
  validates :description, :presence => true, :length => {:maximum => 255}
  validates :domain, :presence => true
  validates :http_protocol, :inclusion => {:in => ['http', 'https']}
  validates :support_email, :presence => true, :email => true
  validates :website_url, :url => true
  validates :privacy_policy_url, :url => {:allow_blank => true}
  validates :time_zone, :presence => true

  default_value :time_zone, -> { 'UTC' }

  attachment :logo
  attachment :cover_image

  florrick do
    string :title
    string :description
    string :domain
    string :domain_with_protocol
    string :http_protocol
    string :support_email
    string :website_url
    string :time_zone
    string(:logo) { logo ? logo.path : nil }
    string(:cover_image) { cover_image ? cover_image.path : nil }
  end

  def domain_with_protocol
    "#{http_protocol}://#{domain}"
  end

  def self.seed
    seed_data.each do |site_attributes|
      site_id = site_attributes[:site_id]
      next if find_by_id(site_id)
      site = create(site_attributes)
      site.save
    end
  end

  def self.seed_file_name
    @seed_file_name ||= Rails.root.join("db", "fixtures", "#{table_name}.yaml")
  end
  private_class_method :seed_file_name

  def self.seed_data
    File.exist?(seed_file_name) ? YAML.load_file(seed_file_name) : []
  end
  private_class_method :seed_data

end
