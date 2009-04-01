module Thumblemonks
  module Oughta
    module MacroMacros
      module ClassMethods
        
        def macro(name, &block)
          (class << self; self; end).instance_eval do 
            define_method(:"Macro: #{name}") { |context| context.instance_eval(&block) }
          end
        end
        
        def use_macro(name)
          send(:"Macro: #{name}", Shoulda.current_context || self)
        end
      end
    end # MacroMacros
  end   # Oughta
end     # Thumblemonks

module Test # :nodoc: all
  module Unit
    class TestCase
      extend Thumblemonks::Oughta::MacroMacros::ClassMethods
    end
  end
end

