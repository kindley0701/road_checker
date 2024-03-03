class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :drive_diaries, dependent: :destroy
  
  #SNS認証による情報からユーザーを取得
  def self.from_omniauth(auth)
    #SNS認証情報(email)から顧客を取得：.first_or_initializeは顧客情報が存在すれば.find，存在しなければ.newと同義．
    customer = Customer.where(email: auth.info.email).first_or_initialize(
      email: auth.info.email,
      provider: auth.provider, #情報提供元のSNS
      customer_id: auth.uid
    )
    customer #取得した顧客を返す．
  end
end
