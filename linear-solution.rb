
class Player
  def play_turn(warrior)
    if warrior.look.any? { |space| space.enemy? } || warrior.health > @health
      warrior.shoot!
    else
      if warrior.feel(:backward).wall? || @checked == true
        warrior_moves(warrior, :forward)
        @checked = true
      elsif warrior.feel.wall?
        warrior.pivot!
      else
        warrior_moves(warrior, :backward)
        @checked = false
      end
    end
  end
  
  def warrior_moves(warrior, direction)
    if warrior.feel(direction).enemy?
      warrior.attack!(direction)
    elsif warrior.feel(direction).captive?
      warrior.rescue!(direction)
    else
      if warrior.health == 20
        warrior.walk!(direction)
      elsif warrior.health < @health && warrior.health < 10
        warrior.walk!(:backward)
      elsif warrior.health < @health
        warrior.walk!(direction)
      else
        warrior.rest!
      end
    end
    @health = warrior.health
  end
end