class AddMoreDetailsToIssueUpdate < ActiveRecord::Migration[5.1]
  def change
    add_column :issue_updates, :image_url, :string
    add_column :issue_updates, :rule_url, :string
  end
end
