class InitSchema < ActiveRecord::Migration[5.2]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "pg_trgm"
    enable_extension "plpgsql"
    create_table "adjustments", id: :serial, force: :cascade do |t|
      t.integer "agenda_id"
      t.integer "user_id"
      t.boolean "presence", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deleted_at"
      t.integer "row_order"
      t.index ["agenda_id"], name: "index_adjustments_on_agenda_id"
      t.index ["deleted_at"], name: "index_adjustments_on_deleted_at"
      t.index ["user_id"], name: "index_adjustments_on_user_id"
    end
    create_table "agendas", id: :serial, force: :cascade do |t|
      t.integer "parent_id"
      t.integer "index", default: 1
      t.string "sort_index"
      t.string "title"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deleted_at"
      t.text "description"
      t.string "short"
      t.integer "status", default: 0, null: false
      t.index ["deleted_at"], name: "index_agendas_on_deleted_at"
      t.index ["parent_id"], name: "index_agendas_on_parent_id"
    end
    create_table "audits", id: :serial, force: :cascade do |t|
      t.integer "auditable_id"
      t.string "auditable_type"
      t.integer "user_id"
      t.integer "updater_id"
      t.integer "vote_id"
      t.json "audited_changes", default: {}, null: false
      t.string "action"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["auditable_type", "auditable_id"], name: "index_audits_on_auditable_type_and_auditable_id"
      t.index ["updater_id"], name: "index_audits_on_updater_id"
      t.index ["user_id"], name: "index_audits_on_user_id"
      t.index ["vote_id"], name: "index_audits_on_vote_id"
    end
    create_table "documents", id: :serial, force: :cascade do |t|
      t.string "pdf", limit: 255
      t.string "title", limit: 255
      t.boolean "public", default: true, null: false
      t.string "category", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "user_id"
      t.integer "agenda_id"
      t.index ["agenda_id"], name: "index_documents_on_agenda_id"
      t.index ["user_id"], name: "index_documents_on_user_id"
    end
    create_table "items", force: :cascade do |t|
      t.string "title", null: false
      t.integer "type", default: 0, null: false
      t.integer "multiplicity", default: 0, null: false
      t.integer "position"
      t.datetime "deleted_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["deleted_at"], name: "index_items_on_deleted_at"
    end
    create_table "news", id: :serial, force: :cascade do |t|
      t.string "title", limit: 255
      t.text "content"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "user_id"
      t.string "url"
      t.index ["user_id"], name: "index_news_on_user_id"
    end
    create_table "sub_items", force: :cascade do |t|
      t.string "title"
      t.integer "position"
      t.bigint "item_id", null: false
      t.integer "status", default: 0, null: false
      t.datetime "deleted_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["deleted_at"], name: "index_sub_items_on_deleted_at"
      t.index ["item_id"], name: "index_sub_items_on_item_id"
    end
    create_table "users", id: :serial, force: :cascade do |t|
      t.string "email", limit: 255, default: "", null: false
      t.string "firstname", limit: 255, default: "", null: false
      t.string "lastname", limit: 255, default: "", null: false
      t.string "encrypted_password", limit: 255, default: "", null: false
      t.string "reset_password_token", limit: 255
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip", limit: 255
      t.string "last_sign_in_ip", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "unconfirmed_email"
      t.datetime "deleted_at"
      t.boolean "presence", default: false, null: false
      t.string "votecode"
      t.string "card_number"
      t.integer "role", default: 0, null: false
      t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
      t.index ["deleted_at"], name: "index_users_on_deleted_at"
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["votecode"], name: "index_users_on_votecode", unique: true
    end
    create_table "vote_options", id: :serial, force: :cascade do |t|
      t.string "title"
      t.integer "count", default: 0
      t.integer "vote_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deleted_at"
      t.index ["deleted_at"], name: "index_vote_options_on_deleted_at"
      t.index ["vote_id"], name: "index_vote_options_on_vote_id"
    end
    create_table "vote_posts", id: :serial, force: :cascade do |t|
      t.integer "vote_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deleted_at"
      t.integer "user_id"
      t.integer "selected", default: 0, null: false
      t.index ["deleted_at"], name: "index_vote_posts_on_deleted_at"
      t.index ["user_id"], name: "index_vote_posts_on_user_id"
      t.index ["vote_id"], name: "index_vote_posts_on_vote_id"
    end
    create_table "votes", id: :serial, force: :cascade do |t|
      t.string "title"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "deleted_at"
      t.integer "choices", default: 1
      t.integer "agenda_id"
      t.integer "present_users", default: 0, null: false
      t.integer "status", default: 0, null: false
      t.index ["agenda_id"], name: "index_votes_on_agenda_id"
      t.index ["deleted_at"], name: "index_votes_on_deleted_at"
    end
    add_foreign_key "adjustments", "agendas"
    add_foreign_key "adjustments", "users"
    add_foreign_key "audits", "users"
    add_foreign_key "audits", "votes"
    add_foreign_key "documents", "agendas"
    add_foreign_key "sub_items", "items"
    add_foreign_key "vote_options", "votes"
    add_foreign_key "vote_posts", "users"
    add_foreign_key "vote_posts", "votes"
    add_foreign_key "votes", "agendas"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
