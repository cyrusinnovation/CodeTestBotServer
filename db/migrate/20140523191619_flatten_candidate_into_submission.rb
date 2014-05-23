class FlattenCandidateIntoSubmission < ActiveRecord::Migration
  def up
    change_table :submissions do |t|
      t.column :candidate_name, :string
      t.column :candidate_email, :string
      t.belongs_to :level
    end

    execute <<-SQL
      UPDATE submissions AS s
        SET candidate_name = c.name, candidate_email = c.email, level_id = c.level_id
        FROM candidates AS c
        WHERE s.candidate_id = c.id
    SQL

    change_table :submissions do |t|
      t.remove_belongs_to :candidate
    end

    drop_table :candidates
  end

  def down
    create_table :candidates do |t|
      t.column :name, :string
      t.column :email, :string
      t.belongs_to :level
      t.timestamps
    end

    execute <<-SQL
      INSERT INTO candidates (name, email, level_id)
      SELECT DISTINCT s.candidate_name, s.candidate_email, s.level_id
      FROM submissions s
    SQL

    change_table :submissions do |t|
      t.belongs_to :candidate
      t.remove_belongs_to :level
    end

    execute <<-SQL
      UPDATE submissions s
      SET candidate_id = c.id
      FROM candidates c
      WHERE s.candidate_email = c.email
    SQL

    change_table :submissions do |t|
      t.remove :candidate_name
      t.remove :candidate_email
    end
  end
end
