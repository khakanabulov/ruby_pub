# frozen_string_literal: true

class CreateRkn5 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn5 do |t|
      t.string :regno
      t.string :org_name
      t.string :short_org_name
      t.string :location
      t.string :license_num
      t.string :geo_zone
      t.string :order_num
      t.string :cancellation_num
      t.date :order_date
      t.date :cancellation_date
    end
  end
end
