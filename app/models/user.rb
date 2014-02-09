class User < ActiveRecord::Base
   has_many :o_auth2_credentials, dependent: :destroy
   has_many :movies, dependent: :destroy

   validates :uid, presence: true
   validates :email, uniqueness: { case_sensitive: false }, if: ->(u){ u.email.present? }

   def full_name
    "#{name} #{surname}"
  end
end
