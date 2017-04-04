class Poster < ApplicationRecord
    enum size: [ :thumbnail, :small, :medium, :large ]
    validates :film_id, uniqueness: { scope: :size }

    belongs_to :film
end
