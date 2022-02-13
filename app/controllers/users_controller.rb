class UsersController < ApplicationController

    def index
        @users = User.join_post_all
        #logger.debug "user.all : #{@users.size}"
        @users = @users.search_user_id_or_email(params[:user_id_or_email]) if params[:user_id_or_email].present?
        render :json => @users
    end

    def show
        @user = User.join_post_find_id(params[:id])
        render :json => @user
    end

    def create
        @user = User.new(get_user_param)
        @user.id = nil
        if @user.save
            render :json => @user
        else
            error_messages = @user.extraction_error_message
            render :json => error_messages, status: :unprocessable_entity
        end
    end

    def update
        @user = User.find(get_id.fetch(:id))

        if @user.update(get_user_param)
            render :json => @user
        else
            error_messages = @user.extraction_error_message
            render :json => error_messages, status: :unprocessable_entity
        end
    end

    def userIdList
        @users = User.get_user_id_list
        render :json => @users
    end

    private

    def get_id
        params.require(:user).permit(:id)
    end

    def get_user_param
        params
        .require(:user)
        .permit(
            :id,
            :user_name,
            :user_id,
            :password,
            :password_confirmation,
            :self_introduction,
            :email,
            :phone_number,
            :birthday,
            :image,
            :can_like_notification,
            :can_comment_notification,
            :can_message_notification,
            :can_calender_notification,
            :is_delete,
            :created_at,
            :update_at
        )
    end
end
