# frozen_string_literal: true

class Sro < ApplicationRecord
  self.table_name = :sro

  has_many :sro_members
  has_many :sro_kinds
end
