# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111203203855) do

  create_table "contribute_relationships", :force => true do |t|
    t.integer  "contributor_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contribute_relationships", ["contributor_id", "project_id"], :name => "index_contribute_relationships_on_contributor_id_and_project_id", :unique => true
  add_index "contribute_relationships", ["contributor_id"], :name => "index_contribute_relationships_on_contributor_id"
  add_index "contribute_relationships", ["project_id"], :name => "index_contribute_relationships_on_project_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "contact_email"
    t.string   "website"
    t.string   "phone"
    t.text     "mission"
    t.text     "details"
    t.integer  "user_id"
    t.string   "verification_token"
    t.boolean  "verified",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["name"], :name => "index_organizations_on_name", :unique => true

  create_table "projects", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.text     "details"
    t.text     "goals"
    t.string   "status"
    t.string   "verification_token"
    t.boolean  "verified",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organization_id"], :name => "index_projects_on_organization_id"

  create_table "taggeds", :force => true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggeds", ["taggable_id", "taggable_type", "tag_id"], :name => "index_taggeds_on_taggable_id_and_taggable_type_and_tag_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "tag_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name", "tag_type"], :name => "index_tags_on_name_and_tag_type", :unique => true
  add_index "tags", ["name"], :name => "index_tags_on_name"
  add_index "tags", ["tag_type"], :name => "index_tags_on_tag_type"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "phone"
    t.string   "current_employer"
    t.string   "job_title"
    t.text     "degrees"
    t.text     "experience"
    t.string   "website"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["name"], :name => "index_user_profiles_on_name"
  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "is_admin"
    t.boolean  "is_organization"
    t.string   "email_token"
    t.boolean  "verified",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
