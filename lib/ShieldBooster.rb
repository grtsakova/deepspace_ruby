# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'ShieldToUI.rb'

module Deepspace
  class ShieldBooster
    attr_reader :name, :boost, :uses
    
    def initialize(name, boost, uses)
      @name = name
      @boost = boost
      @uses = uses
    end
    
    def self.newCopy(c)
      new(c.name, c.boost, c.uses)
    end
    
    def getUIversion
      ShieldToUI.new(self)
    end
    
    def useIt
      if @uses > 0
        @uses -= 1
        return @boost
      else
        return 1.0
      end
    end
    
    def to_s
      return "name: #{@name} boost: #{@boost} uses: #{@uses}"
    end
    
    
    
  end
end
