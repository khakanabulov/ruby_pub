# frozen_string_literal: true

class CreateRkn6 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn6 do |t|
      t.string :pd_operator_num
      t.date :enter_date
      t.string :enter_order
      t.string :status
      t.string :name_full
      t.string :inn
      t.string :address
      t.date :income_date
      t.string :territory
      t.string :purpose_txt
      t.string :basis
      t.string :rf_subjects
      t.string :encryption
      t.string :transgran
      t.string :db_country
      t.string :is_list
      t.string :resp_name
      t.date :startdate
      t.string :stop_condition
      t.string :enter_order_num
      t.date :enter_order_date
    end
  end
end
