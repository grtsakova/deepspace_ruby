# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'SpaceStation.rb'
require_relative 'Transformation.rb'
require_relative 'SpaceCityToUI.rb'

module Deepspace
  
  class SpaceCity < SpaceStation
    
    attr_reader :collaborators
    
    def initialize(base, rest)
      copy(base)
      @base = base
      @collaborators = Array.new
      for i in 0...rest.size do
        @collaborators << rest.at(i)
      end
    end
    
    def getUIversion
      SpaceCityToUI.new(self)
    end
    
    def fire
      fire = super
      for i in 0...@collaborators.size do
        fire += @collaborators.at(i).fire
      end
      return fire
    end
    
    def protection
      protection = super
      for i in 0...@collaborators.size do
        fire += @collaborators.at(i).protection
      end
      return fire
    end
    
    def setLoot(loot)
      super(loot)
      return Transformation::NOTRANSFORM
    end
    
    def to_s
      out = super
      out += "\n ------- My Collaborators are:"
      for c in @collaborators do
        out += "\n --- Collaborator --- \n"
        out += c.to_s
      end
      out += "\n ------- No More Collaborators \n"
      return out
    end
    
  end
end