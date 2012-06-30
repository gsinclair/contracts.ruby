require 'lib/contracts'
require 'fixtures/fixtures'

include Contracts

describe "Contracts:" do
  before :all do
    @o = Object.new
  end

  describe "basic" do
    it "should fail for insufficient arguments" do
      expect {
        @o.hello
      }.to raise_error
    end

    it "should fail for insufficient contracts" do
      expect { @o.bad_double(2) }.to raise_error
    end
  end

  describe "class methods" do
    it "should pass for correct input" do
      expect { Object.a_class_method(2) }.to_not raise_error
    end

    it "should fail for incorrect input" do
      expect { Object.a_class_method("bad") }.to raise_error
    end
  end

  describe "classes" do
    it "should pass for correct input" do
      expect { @o.hello("calvin") }.to_not raise_error
    end

    it "should fail for incorrect input" do
      expect { @o.hello(1) }.to raise_error
    end
  end

  describe "classes with a valid? class method" do
    it "should pass for correct input" do
      expect { @o.double(2) }.to_not raise_error
    end

    it "should fail for incorrect input" do
      expect { @o.double("bad") }.to raise_error
    end
  end

  describe "Procs" do
    it "should pass for correct input" do
      expect { @o.square(2) }.to_not raise_error
    end

    it "should fail for incorrect input" do
      expect { @o.square("bad") }.to raise_error
    end  
  end

  describe "Arrays" do
    it "should pass for correct input" do
      expect { @o.sum_three([1, 2, 3]) }.to_not raise_error
    end

    it "should fail for insufficient items" do
      expect { @o.square([1, 2]) }.to raise_error
    end

    it "should fail for some incorrect elements" do
      expect { @o.sum_three([1, 2, "three"]) }.to raise_error
    end
  end

  describe "Hashes" do
    it "should pass for exact correct input" do
      expect { @o.person({:name => "calvin", :age => 10}) }.to_not raise_error
    end

    it "should pass even if some keys don't have contracts" do
      expect { @o.person({:name => "calvin", :age => 10, :foo => "bar"}) }.to_not raise_error
    end

    it "should fail if a key with a contract on it isn't provided" do
      expect { @o.person({:name => "calvin"}) }.to raise_error
    end

    it "should fail for incorrect input" do
      expect { @o.person({:name => 50, :age => 10}) }.to raise_error    
    end    
  end

  describe "blocks" do
    it "should pass for correct input" do
      expect { @o.call {
        2 + 2
      }}.to_not raise_error
    end

    it "should fail for incorrect input" do
      expect { @o.call() }.to raise_error
    end
  end

  describe "varargs" do
    it "should pass for correct input" do
      expect { @o.sum(1, 2, 3) }.to_not raise_error
    end

    it "should fail for incorrect input" do
      expect { @o.sum(1, 2, "bad") }.to raise_error
    end  
  end

  describe "failure callbacks" do
    before :each do
      @old = (::Contract).method(:failure_callback)
      def (::Contract).failure_callback(data)
        false
      end
    end

    it "should not call a function for which the contract fails when failure_callback returns false" do
      res = @o.double("bad")
      res.should == nil
    end

    after :each do
      def (::Contract).failure_callback(data)
        @old.bind(self).call(data)
      end
    end
  end

  describe "success callbacks" do
    before :each do
      @old = (::Contract).method(:success_callback)
      def (::Contract).success_callback(data)
        false
      end
    end

    it "should not call a function for which the contract succeeds when success_callback returns false" do
      res = @o.double(2)
      res.should == nil
    end

    after :each do
      def (::Contract).success_callback(data)
        @old.bind(self).call(data)
      end
    end
  end  
end
