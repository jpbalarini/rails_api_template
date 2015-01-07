# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  authentication_token   :string(255)      default("")
#  username               :string(255)      default("")
#  first_name             :string(255)      default("")
#  last_name              :string(255)      default("")
#  welcome_screen         :boolean          default(TRUE)
#  how_to_trade           :boolean          default(TRUE)
#  notifications          :boolean          default(TRUE)
#  facebook_id            :string(255)      default("")
#

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates :username, uniqueness: true, allow_blank: true, allow_nil: true
  validates :email, uniqueness: true, allow_blank: true, allow_nil: true
  validates :encrypted_password, uniqueness: false, allow_nil: true

  include Facebookeable

  def invalidate_token
    self.authentication_token = ''
    self.save!
  end

  def full_name
    if first_name.blank?
      username
    else
      first_name + ' ' + last_name
    end
  end

  protected

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    false
  end
end
