# frozen_string_literal: true

class CreateOpendataRkn10 < ActiveRecord::Migration[7.0]
  def change
    create_table :opendata_rkn10 do |t|
      t.string :name, unique: true
      t.string :date
      t.string :owner
      t.string :place
      t.string :type
      t.string :date_from
      t.string :date_to
      t.string :suspension_info
      t.string :renewal_info
      t.string :annulled_info
    end
  end
end
