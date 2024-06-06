# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative 'ShieldBooster.rb'
require_relative 'Weapon.rb'
require_relative 'HangarToUI.rb'

module Deepspace
class Hangar
  
  attr_reader :maxElements, :shieldBoosters, :weapons
  
  def initialize(capacity)
    @maxElements = capacity 
    @shieldBoosters = Array.new()
    @weapons = Array.new()
  end
  
  def self.newCopy(h)
    copia = new(h.maxElements)
    
    for i in 0...h.shieldBoosters.size do
      copia.addShieldBooster(h.shieldBoosters[i])
    end
    
    for i in 0...h.weapons.size do
      copia.addWeapon(h.weapons[i])
    end
    
    return copia
  end
  
  def getUIversion
    HangarToUI.new(self)
  end
  
  def spaceAvailable
    return(@maxElements > @shieldBoosters.size + @weapons.size)
  end
  
  private :spaceAvailable
  
  def addWeapon(w)
    if(spaceAvailable()) then
      @weapons.push(w)
      return true
    else
      return false
    end
  end
  
  def addShieldBooster(s)
    if(spaceAvailable()) then
      @shieldBoosters.push(s)
      return true
    else
      return false
    end
  end
  
  def removeShieldBooster(s)
    if (s >= 0 && s < @shieldBoosters.size) then
      return @shieldBoosters.delete_at(s)
    else
      return nil
    end
  end
  
  def removeWeapon(w)
    if (w >= 0 && w < @weapons.size) then
      return @weapons.delete_at(w)
    else
      return nil
    end
  end
  
  def to_s
    return "MaxElements: #{@maxElements}, ShieldBoosters: #{@shieldBoosters}, Weapons: #{@weapons}"
  end

end
end
