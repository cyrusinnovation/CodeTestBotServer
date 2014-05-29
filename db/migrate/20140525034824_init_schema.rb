class InitSchema < ActiveRecord::Migration
  def up
    
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    
    create_table "assessments", force: true do |t|
      t.integer  "submission_id"
      t.integer  "assessor_id"
      t.integer  "score"
      t.text     "notes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "languages", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "levels", force: true do |t|
      t.string   "text"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "roles", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "sessions", force: true do |t|
      t.integer  "user_id"
      t.string   "token"
      t.datetime "token_expiry"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "submissions", force: true do |t|
      t.text     "email_text"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "zipfile_file_name"
      t.string   "zipfile_content_type"
      t.integer  "zipfile_file_size"
      t.datetime "zipfile_updated_at"
      t.integer  "language_id"
      t.boolean  "active",               default: true
      t.string   "candidate_name"
      t.string   "candidate_email"
      t.integer  "level_id"
    end
    
    create_table "users", force: true do |t|
      t.string   "name"
      t.string   "email"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "uid"
      t.boolean  "editable",   default: true
      t.string   "image_url"
      t.integer  "role_id"
    end
    
  end

  def down
    raise "Can not revert initial migration"
  end
end
