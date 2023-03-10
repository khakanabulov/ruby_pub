# frozen_string_literal: true

class CreateRkn26 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn26 do |t|
      t.string :entryNum
      t.date :entryDate
      t.string :serviceName
      t.string :owner
    end
  end
end
