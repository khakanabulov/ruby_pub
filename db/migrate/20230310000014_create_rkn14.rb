# frozen_string_literal: true

class CreateRkn14 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn14 do |t|
      t.string :rowNumber
      t.string :name
      t.string :measure
      t.string :okei
      t.string :totalSum
    end
  end
end
