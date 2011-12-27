class NewsletterSubscribersController < ApplicationController

  def index
  end

  def show
  end

  def new
  end

  def create
    @subscriber = NewsletterSubscriber.new(params[:newsletter_subscriber])

    if @subscriber.save
      NewsletterSubscriberMailer.newsletter_subscription_confirmation(@subscriber).deliver
      flash[:success] = "You have successfully subscribed to the AustinProBono newsletter!"
    else
      flash[:error] = "There was an error subscribing you."
    end

    redirect_back_or root_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
