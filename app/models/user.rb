class User < ApplicationRecord
    # Include default devise modules.
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable,
            :confirmable, :omniauthable
    include DeviseTokenAuth::Concerns::User

    has_many :post
    has_many :like
    has_many :message
    has_many :message_user

    #has_secure_password

    UniquenessErrorMessage = "この%{attribute}はすでに使用済みです"

    validates :name, presence: true, length: {maximum: 45, message: "45文字以下で入力してください"}
    validates :user_id, presence: true, uniqueness: {message: UniquenessErrorMessage}, length: {maximum: 45, message: "45文字以下で入力してください"}
    validates :self_introduction, length: {maximum: 120, message: "120文字以下で入力してください"}
    validates :email, presence: true, uniqueness: {message: UniquenessErrorMessage}, length: {maximum: 256, message: "256文字以下で入力してください"}
    validates :phone_number, uniqueness: {message: UniquenessErrorMessage}, length: {maximum: 11, message: "11文字以下で入力してください"}, numericality: {message: "数値のみを入力してください"}
    validates :birthday, presence: true
    validate :is_date_correct_format , :date_valid

    #値取得
    def self.join_post_all()
        User.order(user_id: :ASC)
    end

    def self.search_user_id_or_email(parameter)
        Rails.logger.debug "parameter.to_s #{parameter.to_s}"
        users = self.where("user_id like ? or email like ?", "%#{parameter.to_s}%", "%#{parameter.to_s}%").order(user_id: :ASC)
    end

    #from句にselectした結果を持たせる書き方
    # Post_count_query = "(SELECT COUNT(id) AS post_count FROM posts WHERE user_id = ?) AS post_count_query"
    # Like_count_query = "(SELECT COUNT(likes.id) AS like_count FROM posts INNER JOIN likes ON posts.id = likes.post_id WHERE posts.user_id = ?) AS like_count_query"
    # Follow_count_query = "(SELECT COUNT(follower_user_id) AS follow_count FROM follows WHERE follow_user_id = ? ) AS follow_count_query"
    # Follower_count_query = "(SELECT COUNT(follow_user_id) AS follower_count FROM follows WHERE follower_user_id = ? ) AS follower_count_query"
    # Message_user_count_query = "(SELECT COUNT(opposite_user_id) AS message_user_count FROM message_users WHERE user_id = ?) AS message_user_count_query"
    # def self.join_post_find_id(id)
    #     sanitize_post_count_query = User.sanitize_sql_array([Post_count_query, id])
    #     sanitize_like_count_query = User.sanitize_sql_array([Like_count_query, id])
    #     sanitize_follow_count_query = User.sanitize_sql_array([Follow_count_query, id])
    #     sanitize_follower_count_query = User.sanitize_sql_array([Follower_count_query, id])
    #     sanitize_message_user_count_query = User.sanitize_sql_array([Message_user_count_query, id])
    #     User.select('*').from("#{sanitize_post_count_query}, #{sanitize_like_count_query}, #{sanitize_follow_count_query}, #{sanitize_follower_count_query}, #{sanitize_message_user_count_query}, users")
    #                .where('users.id = ?', id).order(user_id: :ASC)
    # end

    def self.join_post_find_id(id)
        User.where('users.id = ?', id).order(user_id: :ASC)
    end

    def self.get_user_id_list
        User.order(user_id: :ASC).pluck(:user_id)
    end

    def self.get_user_by_user_id(user_id)
        self.where('users.user_id = ? and users.is_delete = False',  user_id).first
    end

    #バリデーション
    def is_date_correct_format
        unless %r{\d{4}-\d{2}-\d{2}}.match(birthday.to_s)
            errors.add(:birthday, "2000/01/01の形式で入力してください")
        end
    end

    def date_valid
        Date.parse(birthday.to_s) rescue errors.add(:birthday, "有効な日付を入力してください")
    end

end