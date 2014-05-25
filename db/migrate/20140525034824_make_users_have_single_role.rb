class MakeUsersHaveSingleRole < ActiveRecord::Migration
  def up 
    change_table :users do |t|
      t.belongs_to :role
    end

    execute <<-SQL
      UPDATE users u
      SET role_id = urole.highest
      FROM (
        SELECT u.id, MAX(ru.role_id) AS highest
        FROM users u
        JOIN roles_users ru
          ON u.id = ru.user_id
        GROUP BY u.id
      ) AS urole
      WHERE u.id = urole.id
    SQL

    drop_table :roles_users
  end

  def down
    raise ActiveRecord::IrreverisbleMigration
  end
end
