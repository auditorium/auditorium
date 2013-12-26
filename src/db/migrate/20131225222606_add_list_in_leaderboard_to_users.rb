class AddListInLeaderboardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :list_in_leaderboard, :boolean, default: true
  end
end
