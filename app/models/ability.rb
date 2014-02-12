class Ability
  include CanCan::Ability

  def initialize(user)
    home_abilites

    unless user.nil?
      movie_abilities
    end
  end

private

  def home_abilites
    can :index, :home
  end

  def movie_abilities
    can [:index, :new, :create], Movie
  end

end
