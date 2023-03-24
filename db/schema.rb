# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_22_070007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "black_list", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "patronymic"
    t.string "birthday"
  end

  create_table "clients", id: false, force: :cascade do |t|
    t.uuid "id"
    t.string "login"
    t.string "password"
    t.string "description"
    t.string "jwt_token"
    t.integer "request_count"
    t.string "config"
  end

  create_table "expired_passports", force: :cascade do |t|
    t.string "passp_series"
    t.string "passp_number"
  end

  create_table "fssp_wanted", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "patronymic"
    t.string "birthday"
    t.string "region_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "revoked_at", precision: nil
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "opendata", force: :cascade do |t|
    t.string "number"
    t.string "status"
    t.string "rows"
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "opendata_fsrar", force: :cascade do |t|
    t.string "name"
    t.string "inn"
    t.string "kpp"
    t.string "address_1"
    t.string "email"
    t.string "address_2"
    t.string "kpp_2"
    t.string "region_code"
    t.string "region_code_2"
    t.string "kind"
    t.string "license_num"
    t.string "license_from"
    t.string "license_to"
    t.string "reestr_num"
    t.string "license_info"
    t.string "license_info_updated_date"
    t.string "license_info_basis"
    t.string "license_info_history"
    t.string "doc_num"
    t.string "license_organ"
    t.string "coords"
    t.string "service_date"
    t.string "service_info"
    t.string "product_type"
    t.string "change_date"
  end

  create_table "opendata_fssp6", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "actual_address"
    t.string "number_proceeding"
    t.string "date_proceeding"
    t.string "total_number_proceedings"
    t.string "doc_type"
    t.string "doc_date"
    t.string "doc_number"
    t.string "docs_object"
    t.string "execution_object"
    t.string "amount_due"
    t.string "debt"
    t.string "departments"
    t.string "departments_address"
    t.string "debtor_tin"
    t.string "tin_collector"
  end

  create_table "opendata_fssp7", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "actual_address"
    t.string "number_proceeding"
    t.string "date_proceeding"
    t.string "total_number_proceedings"
    t.string "doc_type"
    t.string "doc_date"
    t.string "doc_number"
    t.string "docs_object"
    t.string "execution_object"
    t.string "complete_reason_date"
    t.string "departments"
    t.string "departments_address"
    t.string "debtor_tin"
    t.string "tin_collector"
  end

  create_table "opendata_rkn10", force: :cascade do |t|
    t.string "Num"
    t.string "Date"
    t.string "Owner"
    t.string "Place"
    t.string "Type"
    t.string "DateFrom"
    t.string "DateTo"
    t.string "SuspensionInfo"
    t.string "RenewalInfo"
    t.string "AnnulledInfo"
  end

  create_table "opendata_rkn13", force: :cascade do |t|
    t.string "plan_year"
    t.string "org_name"
    t.string "address"
    t.string "address_activity"
    t.string "ogrn"
    t.string "inn"
    t.string "date_reg"
    t.string "date_last"
    t.string "goal"
    t.string "date_start"
    t.string "work_day_cnt"
    t.string "control_form"
    t.string "orgs"
  end

  create_table "opendata_rkn14", force: :cascade do |t|
    t.string "rowNumber"
    t.string "name"
    t.string "measure"
    t.string "okei"
    t.string "totalSum"
  end

  create_table "opendata_rkn18", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "education"
    t.string "degree"
    t.string "expertiseSubject"
    t.string "accreditationDate"
    t.string "orderNum"
    t.string "validity"
    t.string "status"
  end

  create_table "opendata_rkn2", force: :cascade do |t|
    t.string "name"
    t.string "ownership"
    t.string "name_short"
    t.string "addr_legal"
    t.string "licence_num"
    t.string "lic_status_name"
    t.string "service_name"
    t.string "territory"
    t.string "registration"
    t.string "date_start"
    t.string "date_end"
  end

  create_table "opendata_rkn20", force: :cascade do |t|
    t.string "entryNum"
    t.string "entryDate"
    t.string "distributorName"
    t.string "distributorOGRN"
    t.string "distributorINN"
    t.string "distributorLegalAddress"
    t.string "distributorEmail"
    t.string "distributorPersons"
    t.string "services"
  end

  create_table "opendata_rkn26", force: :cascade do |t|
    t.string "entryNum"
    t.string "entryDate"
    t.string "serviceName"
    t.string "owner"
  end

  create_table "opendata_rkn3", force: :cascade do |t|
    t.string "name"
    t.string "rus_name"
    t.string "reg_number"
    t.string "status_comment"
    t.string "langs"
    t.string "form_spread"
    t.string "territory"
    t.string "territory_ids"
    t.string "staff_address"
    t.string "domain_name"
    t.string "founders"
    t.string "reg_number_id"
    t.string "status_id"
    t.string "form_spread_id"
    t.string "reg_date"
    t.string "annulled_date"
    t.string "suspension_date"
    t.string "termination_date"
  end

  create_table "opendata_rkn5", force: :cascade do |t|
    t.string "regno"
    t.string "org_name"
    t.string "short_org_name"
    t.string "location"
    t.string "license_num"
    t.string "geo_zone"
    t.string "order_num"
    t.string "cancellation_num"
    t.string "order_date"
    t.string "cancellation_date"
  end

  create_table "opendata_rkn6", force: :cascade do |t|
    t.string "pd_operator_num"
    t.string "enter_date"
    t.string "enter_order"
    t.string "status"
    t.string "name_full"
    t.string "inn"
    t.string "address"
    t.string "income_date"
    t.string "territory"
    t.string "purpose_txt"
    t.string "basis"
    t.string "rf_subjects"
    t.string "encryption"
    t.string "transgran"
    t.string "db_country"
    t.string "is_list"
    t.string "resp_name"
    t.string "startdate"
    t.string "stop_condition"
    t.string "enter_order_num"
    t.string "enter_order_date"
  end

  create_table "opendata_rosstat2012", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "opendata_rosstat2013", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "opendata_rosstat2014", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "opendata_rosstat2015", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "opendata_rosstat2016", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "opendata_rosstat2017", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "opendata_rosstat2018", force: :cascade do |t|
    t.string "name"
    t.string "okpo"
    t.string "okopf"
    t.string "okfs"
    t.string "okved"
    t.string "inn"
    t.string "measure"
    t.string "type"
  end

  create_table "sro", force: :cascade do |t|
    t.integer "number"
    t.string "full_name"
    t.string "inn"
    t.string "ogrn"
    t.string "address"
    t.string "website"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sro_kinds", force: :cascade do |t|
    t.integer "sro_id"
    t.integer "sro_member_id"
    t.string "kind"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sro_members", force: :cascade do |t|
    t.integer "sro_id"
    t.string "full_name"
    t.string "inn"
    t.string "ogrn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terrorist_list", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middlename"
    t.string "date_of_birth"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "provider"
    t.string "token"
    t.boolean "admin"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_massive_supervisors", force: :cascade do |t|
    t.string "g1"
    t.string "g2"
    t.string "g3"
    t.string "g4"
    t.string "g5"
  end

  add_foreign_key "authorizations", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
