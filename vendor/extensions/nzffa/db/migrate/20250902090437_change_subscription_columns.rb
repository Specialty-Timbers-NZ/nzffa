class ChangeSubscriptionColumns < ActiveRecord::Migration
  def self.up
    remove_column :subscriptions, :ha_of_planted_trees
    add_column :subscriptions, :business_size, :string
    remove_column :subscriptions, :main_branch_id
    remove_column :subscriptions, :tree_grower_delivery_location
    remove_column :subscriptions, :receive_tree_grower_magazine
    remove_column :subscriptions, :special_interest_groups
    remove_column :subscriptions, :nz_tree_grower_copies
    remove_column :subscriptions, :contribute_to_research_fund
    remove_column :subscriptions, :research_fund_contribution_amount
    remove_column :subscriptions, :research_fund_contribution_is_donation    
  end

  def self.down
  end
end
