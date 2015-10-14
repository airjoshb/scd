class CartsController < ApplicationController

  def show
    cart_ids = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->variation_id','Id:*->price','Id:*->name','Id:*->image', '#' ])
    @cart_line_items = cart_ids
    @variations = Gift.all.collect(&:variations).flatten
    @available_specials = Special.where('start_date < ? AND end_date > ?', DateTime.current, DateTime.current)
    @specials = @available_specials.collect(&:variations).flatten
    @subtotal = cart_total
    respond_to do |format|
      format.html #
      format.js
    end
  end

  def add
    incr_id = REDIS.incrby(:id,  1)
    @id = "Id:#{incr_id}"
    line_item = REDIS.hmset(@id,  :article_id, params[:article_id], :title, params[:title], :image, params[:image])
    REDIS.sadd current_user_cart, incr_id
    render :js => "window.location = '#{cart_path}'"
  end

  def remove
    REDIS.srem current_user_cart, params[:item_id]
    render :js => "window.location = '#{cart_path}'"

  end

  def cart_total
    price = REDIS.sort(current_user_cart, :by => 'NOSORT', :get => ['Id:*->price'])
    total = 0
    price.map {|item| total += item.to_f }
    total
  end

  private

  def current_user_cart
    "cart#{session[:session_id]}"
  end

end
