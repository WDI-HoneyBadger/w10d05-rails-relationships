class Artist < ApplicationRecord
  has_many :albums, dependent: :delete_all
end
