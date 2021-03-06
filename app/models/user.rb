# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string(191)      default(""), not null
#  encrypted_password        :string(191)      default(""), not null
#  name                      :string(191)      not null
#  is_banned                 :boolean          default(FALSE), not null
#  avatar                    :string(191)
#  password                  :string(191)      default("0"), not null
#  topics_count              :integer          default(0), not null
#  replies_count             :integer          default(0), not null
#  notifications_count       :integer          default(0), not null
#  city                      :string(191)
#  company                   :string(191)
#  twitter_account           :string(191)
#  personal_website          :string(191)
#  signature                 :string(191)
#  introduction              :string(191)
#  deleted_at                :datetime
#  reset_password_token      :string(191)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(191)
#  last_sign_in_ip           :string(191)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  role_id                   :integer
#  unread_notification_count :integer          default(0)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
   # :registerable,:recoverable,
  devise :database_authenticatable,
         :rememberable,
         :registerable, 
         :trackable,
         :omniauthable, 
         omniauth_providers:[:github]

  mount_uploader :avatar, AvatarUploader

  acts_as_paranoid

  include CounterStat #统计
  include RoleAble
  include BaseModel

  validates :name, format: { with: /\A[a-zA-Z0-9]+\Z/ }, :allow_blank => false
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ }, :allow_blank => false

  validates_uniqueness_of :name
  validates_uniqueness_of :email

  validates_length_of :city, :maximum => 50, :allow_blank => true
  validates_length_of :company, :maximum => 50, :allow_blank => true
  validates_length_of :twitter_account, :maximum => 191, :allow_blank => true
  validates_length_of :personal_website, :maximum => 191, :allow_blank => true
  validates_length_of :signature, :maximum => 191, :allow_blank => true
  validates_length_of :introduction, :maximum => 191, :allow_blank => true
  
  belongs_to :role
  has_many :topics#, dependent: :destroy
  has_many :replies#, dependent: :destroy

  has_many :attentions#, dependent: :destroy
  has_many :favorites#, dependent: :destroy

  has_many :notifications#, dependent: :destroy

  has_many :event_logs

  has_one :github,->{where(provider:'github')},class_name:'Authentication'
  
  before_create :set_default_role
  
  def to_param
    "#{name}"
  end

  def calendar_data
    Rails.cache.fetch("#{cache_key}/calendar_data",expires_in:5.minutes) do
      event_logs = self.event_logs.where("created_at > ?",1.years.ago).group("date(created_at)").count
      event_logs.map { |date,count| [date.to_time.to_i,count] }.to_h
    end
  end
  
  def download_remote_avatar
    url = self[:avatar]
    if url.present? && url.start_with?("http")
      self.remote_avatar_url = url  
      self.save(validate: false)
    end
  end

  def avatar=(str)
    if str.is_a?(String)
      self[:avatar] = str
    else
      super
    end
  end

  private
  def set_default_role
    self.role = Role.registered
  end

end
