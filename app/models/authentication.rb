# == Schema Information
#
# Table name: authentications
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  uid          :integer
#  provider     :string(191)      not null
#  access_token :string(191)
#  expires_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  uname        :string(191)
#  provider_url :string(191)
#

class Authentication < ActiveRecord::Base
  # attr_accessible :user_id, :provider, :uid, :access_token

  include BaseModel
  
  belongs_to :user

  # validates :provider, :uid, :access_token, presence: true
  validates :provider, :uid, presence: true

  validates :provider, uniqueness: { scope: [:user_id] }, if: Proc.new { |entity| entity.user_id.present? }


end
