# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'EnemyToUI.rb'
require_relative 'ShotResult.rb'
require_relative 'Loot.rb'
require_relative 'Damage.rb'

module Deepspace
  class EnemyStarShip
    
    attr_reader :ammoPower, :damage, :loot, :name, :shieldPower
    
    def initialize(n,a,s,l,d)
      @name = n
      @ammoPower = a
      @shieldPower = s
      @loot = l
      @damage = d
    end
    
    def self.newCopy(e)
      new(e.name, e.ammoPower, e.shieldPower, e.loot, e.damage)
    end
    
    def getUIversion
      EnemyToUI.new(self)
    end
    
    def fire
      return @ammoPower
    end
    
    def protection
      return @shieldPower
    end
    
    def receiveShot(shot)
      if (@shieldPower <= shot) then
        return ShotResult::DONOTRESIST
      else
        return ShotResult::RESIST
      end
      
    end
    
    def to_s
      return "Name: #{@name}, AmmoPower: #{@AmmoPower}, ShieldPower: #{@shieldPower},
      Loot: #{@loot}, Damage: #{@damage}"
    end


  end

end