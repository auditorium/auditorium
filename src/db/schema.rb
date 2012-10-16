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

ActiveRecord::Schema.define(:version => 20121015211437) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "chairs", :force => true do |t|
    t.string   "name"
    t.integer  "institute_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "url"
  end

  add_index "chairs", ["institute_id"], :name => "index_chairs_on_institute_id"

  create_table "course_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "membership_type", :default => "member"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "notifyable_id"
    t.string   "notifyable_type"
    t.boolean  "receive_emails",  :default => true
  end

  add_index "course_memberships", ["course_id"], :name => "index_course_memberships_on_course_id"
  add_index "course_memberships", ["user_id"], :name => "index_course_memberships_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.integer  "term_id"
    t.integer  "lecture_id"
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "sws",         :default => 0
    t.string   "url",         :default => ""
    t.boolean  "approved",    :default => true
    t.integer  "creator_id"
  end

  add_index "courses", ["creator_id"], :name => "index_courses_on_creater_id"
  add_index "courses", ["lecture_id"], :name => "index_courses_on_lecture_id"
  add_index "courses", ["term_id"], :name => "index_courses_on_term_id"

  create_table "email_settings", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "html_format",              :default => true
    t.boolean  "emails_for_subscribtions", :default => true
    t.boolean  "weekly",                   :default => true
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "email_settings", ["user_id"], :name => "index_email_settings_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.integer  "course_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "tutor_id"
    t.integer  "weekday"
    t.date     "beginDate"
    t.date     "endDate"
    t.integer  "week"
    t.string   "url",        :default => ""
    t.string   "building",   :default => ""
    t.string   "room",       :default => ""
  end

  add_index "events", ["course_id"], :name => "index_events_on_course_id"
  add_index "events", ["tutor_id"], :name => "index_events_on_tutor_id"

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

  create_table "faculty_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "faculty_id"
    t.string   "membership_type", :default => "student"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "notifyable_id"
    t.string   "notifyable_type"
  end

  add_index "faculty_memberships", ["faculty_id"], :name => "index_faculty_memberships_on_faculty_id"
  add_index "faculty_memberships", ["user_id"], :name => "index_faculty_memberships_on_user_id"

  create_table "feedbacks", :force => true do |t|
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "read",       :default => false
  end

  create_table "institutes", :force => true do |t|
    t.string   "name"
    t.integer  "faculty_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

  add_index "institutes", ["faculty_id"], :name => "index_institutes_on_faculty_id"

  create_table "lecture_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lecture_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "notifyable_id"
    t.string   "notifyable_type"
  end

  add_index "lecture_memberships", ["lecture_id"], :name => "index_lecture_memberships_on_lecture_id"
  add_index "lecture_memberships", ["user_id"], :name => "index_lecture_memberships_on_user_id"

  create_table "lectures", :force => true do |t|
    t.string   "name"
    t.integer  "chair_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "url",          :default => ""
    t.integer  "sws",          :default => 0
    t.integer  "creditpoints", :default => 0
    t.string   "description",  :default => ""
  end

  add_index "lectures", ["chair_id"], :name => "index_lectures_on_chair_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "memberable_id"
    t.string   "memberable_type"
    t.string   "role",            :default => "member"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "title"
    t.text     "body"
    t.boolean  "read",            :default => false
    t.integer  "notifyable_id"
    t.string   "notifyable_type"
  end

  add_index "notifications", ["notifyable_id"], :name => "index_notifications_on_notifyable_id"
  add_index "notifications", ["receiver_id"], :name => "index_notifications_on_receivers_id"
  add_index "notifications", ["sender_id"], :name => "index_notifications_on_sender_id"

  create_table "periods", :force => true do |t|
    t.string   "weekday"
    t.integer  "duration"
    t.string   "place"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "event_id"
    t.integer  "minute_of_day"
  end

  add_index "periods", ["event_id"], :name => "index_periods_on_event_id"

  create_table "posts", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "post_type"
    t.integer  "parent_id"
    t.integer  "answer_to_id"
    t.integer  "course_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "author_id"
    t.integer  "rating",          :default => 0
    t.integer  "notifyable_id"
    t.string   "notifyable_type"
    t.boolean  "needs_review",    :default => false
    t.boolean  "is_private",      :default => false
    t.datetime "last_activity"
  end

  add_index "posts", ["answer_to_id"], :name => "index_posts_on_answer_to_id"
  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["course_id"], :name => "index_posts_on_course_id"
  add_index "posts", ["parent_id"], :name => "index_posts_on_child_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "points",          :default => 0
    t.integer  "notifyable_id"
    t.string   "notifyable_type"
  end

  add_index "ratings", ["post_id"], :name => "index_ratings_on_post_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "reports", :force => true do |t|
    t.integer  "reporter_id"
    t.text     "body"
    t.boolean  "read",        :default => false
    t.integer  "post_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "reports", ["reporter_id"], :name => "index_reports_on_reporter_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["post_id"], :name => "index_tags_on_post_id"

  create_table "terms", :force => true do |t|
    t.string   "term_type"
    t.date     "beginDate"
    t.date     "endDate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title",                  :default => ""
    t.string   "website"
    t.string   "alternative_email"
    t.integer  "score",                  :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
