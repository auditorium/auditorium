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

ActiveRecord::Schema.define(:version => 20131225232858) do

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

  create_table "announcements", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "rating",        :default => 0
    t.integer  "views"
    t.boolean  "is_private"
    t.integer  "author_id"
    t.integer  "group_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.datetime "last_activity"
  end

  add_index "announcements", ["author_id", "group_id"], :name => "index_announcements_on_author_id_and_group_id"

  create_table "answers", :force => true do |t|
    t.text     "content"
    t.integer  "rating",        :default => 0
    t.integer  "question_id"
    t.integer  "author_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "answer_to_id"
    t.datetime "last_activity"
  end

  add_index "answers", ["answer_to_id"], :name => "index_answers_on_answer_to_id"
  add_index "answers", ["author_id", "question_id"], :name => "index_answers_on_author_id_and_question_id"

  create_table "badges", :force => true do |t|
    t.string   "category",    :default => "bronze"
    t.integer  "score",       :default => 25
    t.string   "title"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "badges_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges_users", ["badge_id"], :name => "index_badges_users_on_badge_id"
  add_index "badges_users", ["user_id"], :name => "index_badges_users_on_user_id"

  create_table "chairs", :force => true do |t|
    t.string   "name"
    t.integer  "institute_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "url"
    t.integer  "jexam_id"
  end

  add_index "chairs", ["institute_id"], :name => "index_chairs_on_institute_id"

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.text     "content"
    t.integer  "rating",           :default => 0
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "last_activity"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"

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
    t.integer  "jexam_id"
  end

  add_index "courses", ["creator_id"], :name => "index_courses_on_creater_id"
  add_index "courses", ["lecture_id"], :name => "index_courses_on_lecture_id"
  add_index "courses", ["term_id"], :name => "index_courses_on_term_id"

  create_table "email_settings", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "daily",                    :default => true
    t.boolean  "emails_for_subscribtions", :default => true
    t.boolean  "weekly",                   :default => true
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "notification_when_author", :default => true
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

  create_table "followings", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followerable_id"
    t.string   "followerable_type"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "role",                  :default => "member"
    t.boolean  "receive_notifications", :default => true
  end

  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"
  add_index "followings", ["followerable_id"], :name => "index_followings_on_followerable_id"
  add_index "followings", ["followerable_type"], :name => "index_followings_on_followerable_type"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "group_type"
    t.integer  "creator_id",    :default => 1
    t.boolean  "private_posts"
    t.string   "url"
    t.boolean  "approved"
    t.boolean  "deactivated",   :default => false
  end

  add_index "groups", ["creator_id"], :name => "index_groups_on_creator_id"

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
    t.text     "description"
    t.integer  "jexam_id"
  end

  add_index "lectures", ["chair_id"], :name => "index_lectures_on_chair_id"

  create_table "levels", :force => true do |t|
    t.integer  "threshold"
    t.integer  "number"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  add_index "levels", ["user_id"], :name => "index_levels_on_user_id"

  create_table "membership_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "membership_type"
    t.boolean  "read",            :default => false
    t.boolean  "confirmed",       :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "group_id"
    t.string   "status",          :default => "pending"
  end

  add_index "membership_requests", ["course_id"], :name => "index_membership_requests_on_course_id"
  add_index "membership_requests", ["group_id"], :name => "index_membership_requests_on_group_id"
  add_index "membership_requests", ["user_id"], :name => "index_membership_requests_on_user_id"

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
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
  end

  add_index "notifications", ["notifiable_id"], :name => "index_notifications_on_notifyable_id"
  add_index "notifications", ["receiver_id"], :name => "index_notifications_on_receivers_id"
  add_index "notifications", ["sender_id"], :name => "index_notifications_on_sender_id"

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
    t.integer  "views",           :default => 0
    t.string   "url"
    t.integer  "group_id"
  end

  add_index "posts", ["answer_to_id"], :name => "index_posts_on_answer_to_id"
  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["course_id"], :name => "index_posts_on_course_id"
  add_index "posts", ["group_id"], :name => "index_posts_on_group_id"
  add_index "posts", ["parent_id"], :name => "index_posts_on_child_id"

  create_table "questions", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "rating",        :default => 0
    t.integer  "views"
    t.boolean  "is_private"
    t.integer  "author_id"
    t.integer  "group_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.datetime "last_activity"
  end

  add_index "questions", ["author_id", "group_id"], :name => "index_questions_on_author_id_and_group_id"

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

  create_table "recordings", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "rating",     :default => 0
    t.integer  "views"
    t.string   "url"
    t.boolean  "is_private"
    t.integer  "author_id"
    t.integer  "group_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "recordings", ["author_id", "group_id"], :name => "index_recordings_on_author_id_and_group_id"

  create_table "reports", :force => true do |t|
    t.integer  "reporter_id"
    t.text     "body"
    t.boolean  "read",        :default => false
    t.integer  "post_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "reports", ["reporter_id"], :name => "index_reports_on_reporter_id"

  create_table "settings", :force => true do |t|
    t.boolean  "receive_emails_when_author",  :default => true
    t.boolean  "receive_email_notifications", :default => true
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "user_id"
  end

  add_index "settings", ["user_id"], :name => "index_settings_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "terms", :force => true do |t|
    t.string   "term_type"
    t.date     "beginDate"
    t.date     "endDate"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "jexam_id",   :default => 0
  end

  create_table "topics", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "rating",        :default => 0
    t.integer  "views"
    t.boolean  "is_private"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "group_id"
    t.integer  "author_id"
    t.datetime "last_activity"
  end

  add_index "topics", ["author_id"], :name => "index_topics_on_author_id"
  add_index "topics", ["group_id"], :name => "index_topics_on_group_id"

  create_table "tutorial_progresses", :force => true do |t|
    t.boolean  "introduction", :default => false
    t.boolean  "groups",       :default => false
    t.boolean  "group",        :default => false
    t.boolean  "question",     :default => false
    t.integer  "user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "tutorial_progresses", ["user_id"], :name => "index_tutorial_progresses_on_user_id"

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
    t.string   "authentication_token"
    t.string   "role"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.boolean  "privacy_policy",         :default => false
    t.integer  "sash_id"
    t.integer  "level_id"
    t.boolean  "list_in_leaderboard",    :default => true
    t.boolean  "experimental_group",     :default => true
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.text     "content"
    t.string   "subject"
    t.string   "url"
    t.integer  "views"
    t.boolean  "is_private"
    t.integer  "author_id"
    t.integer  "group_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "code"
    t.integer  "rating",        :default => 0
    t.datetime "last_activity"
  end

  add_index "videos", ["author_id"], :name => "index_media_on_author_id"
  add_index "videos", ["group_id"], :name => "index_media_on_group_id"

  create_table "votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "value"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votings", ["user_id"], :name => "index_votings_on_user_id"
  add_index "votings", ["votable_id"], :name => "index_votings_on_votable_id"
  add_index "votings", ["votable_type"], :name => "index_votings_on_votable_type"

end
