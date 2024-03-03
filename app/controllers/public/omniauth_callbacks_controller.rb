# frozen_string_literal: true

class Public::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  
  #Google認証用
  def google_oauth2
    authorization #下で定義
  end
  
  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  private

  def authorization
    #SNSアカウントを用いてユーザー情報を取得：引数に入力
    @customer = Customer.from_omniauth(request.env["omniauth.auth"]) #.from_omniauthはモデルで定義．
    
    #未登録であれば，新規登録処理
    unless @customer.persisted? #DBに存在しなければ
      generated_password = Devise.friendly_token(12) #ランダムパスワードの生成
      @customer.password = generated_password #パスワードの設定
      @customer.save  #DBに保存
    end
    # ログイン処理
    sign_in_and_redirect @customer, event: :authentication
    #sign_in_and_redirectは，ログイン処理とafter_sign_in_path_forを兼ねる．
    #event: :authenticationは，Wardenを用いてsessionに値を持たせる：current_userに関係あり？
  end

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
