# frozen_string_literal: true

class CreateRkn13 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn13 do |t|
      t.string :plan_year
      t.string :org_name
      t.string :address
      t.string :address_activity
      t.string :ogrn
      t.string :inn
      t.date :date_reg
      t.date :date_last
      t.string :goal
      t.date :date_start
      t.string :work_day_cnt
      t.string :control_form
      t.string :orgs
    end
  end
end
