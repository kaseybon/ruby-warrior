class Player
  def initialize
      @health = 20
  end
    
  def play_turn(warrior)

    walk = Walk.new warrior
    attack = Attack.new warrior
    health = Health.new warrior
    help = Help.new warrior
    retreat = Retreat.new warrior
    pivot = Pivot.new warrior
    shoot = Shoot.new warrior
    
    for action in [attack, shoot, retreat, health, help, walk, pivot]
      if action.can?(@health)
        action.go!
        break
      end
    end
  
  @health = warrior.health
  end
end

class WarriorAction
  def initialize(warrior)
    @warrior = warrior  
  end
end

class Walk < WarriorAction
  def can?(health)
    @warrior.feel.empty?
  end
  def go!
    @warrior.walk!
  end
end
  
class Attack < WarriorAction
  def can?(health)
    @warrior.feel.enemy?
  end
  def go!
    @warrior.attack!
  end
end

class Health < WarriorAction
  def can?(health)
    @warrior.health < 20 && @warrior.health >= health
  end
  def go!
    @warrior.rest!
  end
end

class Help < WarriorAction
  def can?(health)
    @warrior.feel.captive?
  end
  def go!
    @warrior.rescue!
  end
end

class Retreat < WarriorAction
  def can?(health)
    @warrior.health < health && @warrior.feel(:backward).empty? && @warrior.health < 15
  end
  def go!
    @warrior.walk!(:backward)
  end
end

class Pivot < WarriorAction
  def can?(health)
    @warrior.feel(:backward).empty? || @warrior.feel.wall?
  end
  def go!
    @warrior.pivot!
  end
end

class Shoot < WarriorAction
  def can?(health)
    @warrior.look.any? { |space| space.enemy? } && ! @warrior.look.any? { |space| space.captive? } && @warrior.health >= health
  end
  def go!
    @warrior.shoot!
  end
end