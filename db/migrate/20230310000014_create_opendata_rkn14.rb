# frozen_string_literal: true

class CreateOpendataRkn14 < ActiveRecord::Migration[7.0]
  def change
    create_table :opendata_rkn14 do |t|
      t.string :row_number
      t.string :name, unique: true
      t.string :measure
      t.string :okei
      t.string :totalSum
    end
  end
end
