module Thumblemonks
  module Oughta
    module MacroMacros
      module ClassMethods
        
        # Defines a macro for use in a TestCase or Context with the given name and block.
        # For example, this defines a macro called :should_be_cool
        #
        #   macro :should_be_cool do
        #     
        #     should("be true") { assert(true) }
        #     should("be cool") { assert_equal("cool", @message) }
        #     should_eventually "do something else"
        #
        #   end
        #
        # To then use this macro, see the documentation for use_macro
        #
        def macro(name, &block)
          (class << self; self; end).instance_eval do 
            define_method(:"Macro: #{name}") { |context| context.instance_eval(&block) }
          end
        end
        
        # Uses a macro defined using the macro method. For example:
        #
        #   class TooLazyToSubmitPatchesToThoughtbotTest < Test::Unit::TestCase 
        #
        #     macro :should_be_cool do
        #       should("be cool") { assert_equal("cool", @message) }
        #     end
        #
        #     def setup
        #       @message = "cool"
        #     end
        #     
        #     use_macro :should_be_cool
        #
        #     context "intentionally fails" do
        #       setup { @message = "not cool yo" }
        #       use_macro :should_be_cool
        #     end
        #
        #   end
        #
        def use_macro(*macros)
          macros.each do |name|
            send(:"Macro: #{name}", ::Shoulda.current_context || self)
          end
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

