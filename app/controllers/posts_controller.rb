class PostsController < ApplicationController

  # ****************************************************************************************
    # 一覧取得処理
  # ****************************************************************************************
  def index
    @posts = Post.user_join_all
    @posts = @posts.search_user_id(params[:users_table_user_id]) if params[:users_table_user_id].present?
    @posts = @posts.search_post_contents(params[:post_contents]) if params[:post_contents].present?
    render :json => @posts
  end

  # ****************************************************************************************
    # 単体の投稿情報取得処理
  # ****************************************************************************************
  def show
    @post = Post.get_post(params[:id])
    render :json => @post
  end

  # ****************************************************************************************
    # 登録処理
  # ****************************************************************************************
  def create
    #フォームで入力したユーザーIDのサロゲートキーを取得( 投稿をユーザーを紐づけるために必要 )
    @user = User.get_user_by_user_id(get_users_table_user_id.fetch(:users_table_user_id))

    #入力されたユーザーIDのユーザーが見つかったか？
    if(@user)
      user_id = @user.id
    else
      #見つからなかった場合、バリデーションに引っかかる値を代入
      user_id = 0
    end

    #パラメータにユーザーテーブルのサロゲートキーを設定
    post_param = get_post_param
    post_param[:user_id] = user_id

    @post = Post.new(post_param)
    @post.id = nil

    if @post.save
        render :json => @post
    else
      error_messages = @post.extraction_error_message
      render :json => error_messages, status: :unprocessable_entity
    end
  end

  # ****************************************************************************************
    # 更新処理
  # ****************************************************************************************
  def update
    @post = Post.find(get_id.fetch(:id))

    #投稿画面から送信されたユーザーIDでusersテーブルからusers.idを取得する
    @user = User.get_user_by_user_id(get_users_table_user_id.fetch(:users_table_user_id))

    #入力されたユーザーIDのユーザーが見つかったか？
    if(@user)
      user_id = @user.id
    else
      #見つからなかった場合、バリデーションに引っかかる値を代入
      user_id = 0
    end

    #user_idを追加するためパラメータを取得
    post_param = get_post_param

    #ユーザーIDを更新パラメータに追加
    post_param[:user_id] = user_id

    if @post.update(post_param)
      render :json => @post
    else
      error_messages = @post.extraction_error_message
      render :json => error_messages, status: :unprocessable_entity
    end
  end




  private

  def get_id
    params.require(:post).permit(:id)
  end

  def get_users_table_user_id
    params.require(:post).permit(:users_table_user_id)
  end

  def get_post_param
    params
    .require(:post)
    .permit(
        :id,
        :post_contents,
        :post_image,
        :is_delete,
        :created_at,
    )
  end

end