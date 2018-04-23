class BookEdition < ApplicationRecord
  enum edition: %i[
    reprint
    slp
    special
    rehearsal
    script_ed
    anniversary
    reissue
    unabridged
  ]
  enum binding: %i[hardcover paper_bound vhs laser_disc ebook]
end
