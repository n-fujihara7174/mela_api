class User < ApplicationRecord
    # Include default devise modules.
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable,
            :confirmable, :omniauthable
    include DeviseTokenAuth::Concerns::User

    #########################################################################
    #関連
    #########################################################################
    has_many :posts
    has_many :likes
    has_many :roles, through: :user_role_grants

    #########################################################################
    #バリデーション
    #########################################################################
    #バリデーションメッセージを追加
    UniquenessErrorMessage = "この%{attribute}はすでに使用済みです"

    validates :name, presence: true, uniqueness: {message: UniquenessErrorMessage}, length: {maximum: 45, message: "45文字以下で入力してください"}
    validates :self_introduction, length: {maximum: 120, message: "120文字以下で入力してください"}
    validates :email, presence: true, uniqueness: {message: UniquenessErrorMessage}, length: {maximum: 256, message: "256文字以下で入力してください"}

    #########################################################################
    #select
    #########################################################################
    def self.join_post_all()
        User.order(name: :ASC)
    end

    def self.search_name_or_email(parameter)
        Rails.logger.debug "parameter.to_s #{parameter.to_s}"
        users = self.where("name like ? or email like ?", "%#{parameter.to_s}%", "%#{parameter.to_s}%").order(name: :ASC)
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
        User.where('users.id = ?', id).order(name: :ASC)
    end

    def self.get_name_list
        User.order(name: :ASC).pluck(:name)
    end

    def self.get_user_by_name(name)
        self.where('users.name = ?',  name).first
    end
end