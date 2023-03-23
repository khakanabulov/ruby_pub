# frozen_string_literal: true

class CreateOpendataRosstat2018 < ActiveRecord::Migration[7.0]
  def change
    create_table :opendata_rosstat2018 do |t|
      t.string :name, unique: true
      t.string :okpo
      t.string :okopf
      t.string :okfs
      t.string :okved
      t.string :inn
      t.string :measure
      t.string :type
    end
  end
end
