class CreateUsers < ActiveRecord::Migration
  def change



      create_table "users", :force => true do |t|
        t.string   "name"
        t.string   "email"
        t.string   "role_name"
        t.string   "crypted_password"
        t.string   "password_salt"
        t.string   "persistence_token"
        t.string   "single_access_token"
        t.string   "perishable_token"
        t.integer  "login_count",             :default => 0,     :null => false
        t.integer  "failed_login_count",      :default => 0,     :null => false
        t.datetime "last_request_at"
        t.datetime "current_login_at"
        t.datetime "last_login_at"
        t.string   "current_login_ip"
        t.string   "last_login_ip"
        t.datetime "created_at",                                 :null => false
        t.datetime "updated_at",                                 :null => false
        t.boolean  "blocked",                 :default => false
      
    end
  end
end
