# frozen_string_literal: true

class CreateRkn18 < ActiveRecord::Migration[7.0]
  def change
    create_table :rkn18 do |t|
      t.string :name
      t.string :email
      t.string :education
      t.string :degree
      t.string :expertiseSubject
      t.date :accreditationDate
      t.string :orderNum
      t.string :validity
      t.string :status
    end
  end
end
