class ArticlePolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin?
  end

  def edit?
    user.admin?
  end


  def update?
    user.admin?
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

end