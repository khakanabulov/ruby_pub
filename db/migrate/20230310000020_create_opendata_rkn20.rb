# frozen_string_literal: true

class CreateOpendataRkn20 < ActiveRecord::Migration[7.0]
  def change
    create_table :opendata_rkn20 do |t|
      t.string :entry_num
      t.string :entry_date
      t.string :name
      t.string :ogrn
      t.string :inn
      t.string :legal_address
      t.string :email
      t.string :persons
      t.string :services
    end
  end
end
