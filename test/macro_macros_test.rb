require 'test_helper'

class MacroMacrosTest < Test::Unit::TestCase
  test_variable = []
  
  define_method(:setup) do
    test_variable.clear
    meta_test = Class.new(Test::Unit::TestCase) do
      macro :should_work_as_expected do
        should("jam something into test one") { test_variable << @test_variable }
      end
      
      def setup
        @test_variable = :half_day_closing
      end      
      use_macro :should_work_as_expected

      context "in a context" do
        setup { @test_variable = :portishead }
        use_macro :should_work_as_expected
      end
    end # meta_test
    meta_test.suite.run(Test::Unit::TestResult.new) {}
  end

  should "have run the macro in the top level test context" do
    assert test_variable.include?(:half_day_closing)
  end
  
  should "have run the macro in the defined context" do
    assert test_variable.include?(:portishead)
  end
  
  should "have run the macro in both contexts" do
    assert_same_elements [:portishead, :half_day_closing], test_variable
  end
  
end
