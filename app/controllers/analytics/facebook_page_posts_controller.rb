class Analytics::FacebookPagePostsController < ApplicationController
  def index
    @posts = Analytics::FacebookPageService.get_posts
  end
end
