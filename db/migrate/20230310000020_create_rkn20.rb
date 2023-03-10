# frozen_string_literal: true

class CreateRkn20 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn20 do |t|
      t.string :entryNum
      t.date :entryDate
      t.string :distributorName
      t.string :distributorOGRN
      t.string :distributorINN
      t.string :distributorLegalAddress
      t.string :distributorEmail
      t.string :distributorPersons
      t.string :services
    end
  end
end
