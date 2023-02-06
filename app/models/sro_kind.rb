# frozen_string_literal: true

class SroKind < ApplicationRecord
  belongs_to :sro
  belongs_to :sro_member
end
