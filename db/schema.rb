# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091003095744) do

  create_table "assets", :force => true do |t|
    t.string   "caption"
    t.string   "title"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_token"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "page_id"
    t.string   "author"
    t.string   "author_url"
    t.string   "author_email"
    t.string   "author_ip"
    t.text     "content"
    t.text     "content_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filter_id",    :limit => 25
    t.string   "user_agent"
    t.string   "referrer"
    t.datetime "approved_at"
    t.integer  "approved_by"
    t.string   "mollom_id"
  end

  create_table "config", :force => true do |t|
    t.string "key",         :limit => 40, :default => "", :null => false
    t.string "value",                     :default => ""
    t.text   "description"
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "extension_meta", :force => true do |t|
    t.string  "name"
    t.integer "schema_version", :default => 0
    t.boolean "enabled",        :default => true
  end

  create_table "form_datas", :force => true do |t|
    t.string   "url"
    t.text     "blob"
    t.datetime "exported"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "work_phone_ext"
    t.string   "age_range"
    t.string   "company"
    t.string   "mobile_phone"
    t.string   "last_name"
    t.text     "message"
    t.integer  "household_count"
    t.string   "job_title"
    t.string   "zip"
    t.string   "address"
    t.string   "gender"
    t.string   "industry"
    t.string   "state"
    t.string   "city"
    t.string   "atatchment"
    t.string   "home_phone"
    t.string   "resident_since"
    t.string   "email"
    t.string   "work_phone"
    t.string   "princeton_activities"
    t.string   "first_name"
  end

  add_index "form_datas", ["address"], :name => "index_form_datas_on_address"
  add_index "form_datas", ["age_range"], :name => "index_form_datas_on_age_range"
  add_index "form_datas", ["atatchment"], :name => "index_form_datas_on_atatchment"
  add_index "form_datas", ["city"], :name => "index_form_datas_on_city"
  add_index "form_datas", ["company"], :name => "index_form_datas_on_company"
  add_index "form_datas", ["email"], :name => "index_form_datas_on_email"
  add_index "form_datas", ["first_name"], :name => "index_form_datas_on_first_name"
  add_index "form_datas", ["gender"], :name => "index_form_datas_on_gender"
  add_index "form_datas", ["home_phone"], :name => "index_form_datas_on_home_phone"
  add_index "form_datas", ["household_count"], :name => "index_form_datas_on_household_count"
  add_index "form_datas", ["industry"], :name => "index_form_datas_on_industry"
  add_index "form_datas", ["job_title"], :name => "index_form_datas_on_job_title"
  add_index "form_datas", ["last_name"], :name => "index_form_datas_on_last_name"
  add_index "form_datas", ["message"], :name => "index_form_datas_on_message"
  add_index "form_datas", ["mobile_phone"], :name => "index_form_datas_on_mobile_phone"
  add_index "form_datas", ["princeton_activities"], :name => "index_form_datas_on_princeton_activities"
  add_index "form_datas", ["resident_since"], :name => "index_form_datas_on_resident_since"
  add_index "form_datas", ["state"], :name => "index_form_datas_on_state"
  add_index "form_datas", ["url"], :name => "index_form_datas_on_url"
  add_index "form_datas", ["work_phone"], :name => "index_form_datas_on_work_phone"
  add_index "form_datas", ["work_phone_ext"], :name => "index_form_datas_on_work_phone_ext"
  add_index "form_datas", ["zip"], :name => "index_form_datas_on_zip"

  create_table "layouts", :force => true do |t|
    t.string   "name",                         :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "content_type",                 :limit => 40
    t.integer  "lock_version",                                :default => 0
    t.datetime "draft_promotion_scheduled_at"
    t.datetime "draft_promoted_at"
    t.text     "draft_content"
  end

  create_table "member_categories", :force => true do |t|
    t.integer  "member_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.integer  "category_id"
    t.string   "website"
    t.string   "tagline"
    t.text     "bio"
    t.text     "keywords"
    t.string   "hours"
    t.boolean  "ecommerce"
    t.boolean  "gifts"
    t.string   "news_feed"
    t.string   "events_feed"
    t.string   "products_feed"
    t.date     "member_since"
    t.date     "membership_expires_on"
    t.string   "level"
    t.string   "billing_name"
    t.string   "billing_phone"
    t.string   "billing_email"
    t.string   "status"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin_name"
    t.string   "admin_email"
    t.string   "admin_phone"
    t.string   "admin_password"
    t.integer  "parent_property_id"
    t.string   "category_other"
  end

  create_table "meta_tags", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "meta_tags", ["name"], :name => "index_meta_tags_on_name", :unique => true

  create_table "old_page_attachments", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.integer  "created_by"
    t.datetime "updated_at"
    t.integer  "updated_by"
    t.integer  "page_id"
    t.string   "title"
    t.string   "description"
    t.integer  "position"
  end

  create_table "page_attachments", :force => true do |t|
    t.integer "asset_id"
    t.integer "page_id"
    t.integer "position"
  end

  create_table "page_parts", :force => true do |t|
    t.string   "name",             :limit => 100
    t.string   "filter_id",        :limit => 25
    t.text     "content"
    t.integer  "page_id"
    t.string   "page_part_type"
    t.string   "string_content"
    t.boolean  "boolean_content"
    t.integer  "integer_content"
    t.datetime "datetime_content"
    t.text     "draft_content"
  end

  add_index "page_parts", ["boolean_content"], :name => "index_page_parts_on_boolean_content"
  add_index "page_parts", ["datetime_content"], :name => "index_page_parts_on_datetime_content"
  add_index "page_parts", ["integer_content"], :name => "index_page_parts_on_integer_content"
  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"
  add_index "page_parts", ["string_content"], :name => "index_page_parts_on_string_content"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",                         :limit => 100
    t.string   "breadcrumb",                   :limit => 160
    t.string   "class_name",                   :limit => 25
    t.integer  "status_id",                                   :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                                     :default => false, :null => false
    t.integer  "lock_version",                                :default => 0
    t.string   "description"
    t.string   "keywords"
    t.integer  "position",                                    :default => 0
    t.boolean  "enable_comments",                             :default => false
    t.integer  "comments_count",                              :default => 0
    t.string   "page_factory"
    t.datetime "draft_promotion_scheduled_at"
    t.datetime "draft_promoted_at"
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "roles", :force => true do |t|
    t.string "role_name", :limit => 64, :default => "New Role"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "snippets", :force => true do |t|
    t.string   "name",                         :limit => 100, :default => "", :null => false
    t.string   "filter_id",                    :limit => 25
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version",                                :default => 0
    t.datetime "draft_promotion_scheduled_at"
    t.datetime "draft_promoted_at"
    t.text     "draft_content"
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer "meta_tag_id",   :null => false
    t.integer "taggable_id",   :null => false
    t.string  "taggable_type", :null => false
  end

  add_index "taggings", ["meta_tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_meta_tag_id_and_taggable_id_and_taggable_type", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",          :limit => 100
    t.string   "email"
    t.string   "login",         :limit => 40,  :default => "",    :null => false
    t.string   "password",      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "admin",                        :default => false, :null => false
    t.boolean  "designer",                     :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                 :default => 0
    t.string   "salt"
    t.string   "session_token"
    t.string   "locale"
    t.boolean  "publisher",                    :default => false
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
