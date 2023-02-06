# frozen_string_literal: true

class SroMember < ApplicationRecord
  belongs_to :sro
  has_many :sro_kinds
end
