# frozen_string_literal: true

class CreateRkn3 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn3 do |t|
      t.string :name
      t.string :rus_name
      t.string :reg_number
      t.string :status_comment
      t.string :langs
      t.string :form_spread
      t.string :territory
      t.string :territory_ids
      t.string :staff_address
      t.string :domain_name
      t.string :founders
      t.integer :reg_number_id
      t.integer :status_id
      t.integer :form_spread_id
      t.date :reg_date
      t.date :annulled_date
      t.date :suspension_date
      t.date :termination_date
    end
  end
end
