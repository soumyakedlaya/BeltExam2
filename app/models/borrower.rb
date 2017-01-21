class Borrower < ActiveRecord::Base
  has_secure_password
  has_many :transactions, dependent: :destroy
  has_many :lenders, through: :transactions

  before_validation do
    self.email = email.downcase if email.present?
  end

  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, :purpose, :description, :money, :presence => true
  validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
  validates :password, on: create, :presence => true
end
