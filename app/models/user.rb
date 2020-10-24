class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  before_action :logged_in_user, only: [:edit, :update]

  before_save{self.email = self.email.downcase}#保存する前に大文字を小文字にしよう
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end