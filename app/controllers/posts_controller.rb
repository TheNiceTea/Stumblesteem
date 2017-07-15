class PostsController < ApplicationController
	before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote]
	before_action :authenticate_user!, except: [:index, :show, :random]
	
	require 'net/http'
	
	def index
		if user_signed_in?
			find_posts
		else
		end
	end
	
	def show

	end
	
	def new
		find_posts
		@post = current_user.posts.build
	end

	def create
		find_posts
		@post = current_user.posts.build(post_params)
		if @post.link =~ /https?:\/\/steemit.com/
			if @post.save
				redirect_to root_path
			else
				render 'new'
			end
		else
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to root_path
		else 
			render 'edit'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	def upvote
		@posts.upvote_by current_user
		redirect_to :back
	end

	def random
		@post = Post.find(Random.rand(1..Post.count)) #1..Post.count
		url = URI.parse(@post.link)
		req = Net::HTTP::Post.new(url.request_uri)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = (url.scheme == "https")
		response = http.request(req)
		str1 = "<div class=\"MarkdownViewer Markdown\""
		str2 = "</span>"
	    pre = response.body[/#{str1}(.*?)#{str2}/m, 1]
	   	str1 = "<p>"
	    str2 = "</div>"
	    @content = pre[/#{str1}(.*?)#{str2}/m, 1]
	end

	private

	def find_post
		@post = current_user.posts.find(params[:id])
	end
	def find_posts
		@posts = current_user.posts.all.order("created_at DESC")
	end

	def post_params
		params.require(:post).permit(:title, :link)
	end
end
