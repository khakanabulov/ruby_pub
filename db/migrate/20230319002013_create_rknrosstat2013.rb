# frozen_string_literal: true

class CreateRknrosstat2013 < ActiveRecord::Migration[7.0]
  def change
    create_table :rknrosstat2013 do |t|
      t.string :name
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
