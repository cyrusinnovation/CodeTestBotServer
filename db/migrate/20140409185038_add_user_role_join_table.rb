class AddUserRoleJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :roles
  end
end
