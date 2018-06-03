class User < ApplicationRecord
  has_secure_password

  enum role: %i[reader librarian administrator]
end
