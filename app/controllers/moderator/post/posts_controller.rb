module Moderator
  module Post
    class PostsController < ApplicationController
      before_action :approver_only, :only => [:delete, :undelete, :move_favorites, :confirm_delete, :confirm_move_favorites]
      before_action :admin_only, :only => [:expunge]
      skip_before_action :api_check

      respond_to :html, :json, :xml

      def confirm_delete
        @post = ::Post.find(params[:id])
        @reason = @post.flags.where(is_resolved: false)&.last&.reason || ''
        @reason = "Inferior version of post ##{@post.parent_id}." if @post.parent_id && @reason == ''
      end

      def delete
        @post = ::Post.find(params[:id])
        if params[:commit] == "Delete"
          @post.delete!(params[:reason], :move_favorites => params[:move_favorites].present?)
        end
        redirect_to(post_path(@post))
      end

      def undelete
        @post = ::Post.find(params[:id])
        @post.undelete!
      end

      def confirm_move_favorites
        @post = ::Post.find(params[:id])
      end

      def move_favorites
        @post = ::Post.find(params[:id])
        if params[:commit] == "Submit"
          @post.give_favorites_to_parent
        end
        redirect_to(post_path(@post))
      end

      def expunge
        @post = ::Post.find(params[:id])
        @post.expunge!
      end
    end
  end
end
