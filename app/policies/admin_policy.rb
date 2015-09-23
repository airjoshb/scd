class AdminPolicy < Struct.new(:user, :admin)
  attr_reader :user, :article

  def initialize(user, article)
    @user = user
    @article = article
  end



  def dashboard?
    user.admin?
  end


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

end