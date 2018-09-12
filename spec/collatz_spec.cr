require "spec"
require "../src/collatz"

describe Collatz do
  it "should run Collatz methods" do
    Collatz.runOnce(10).should eq(5)
    Collatz.runOnce(11).should eq(34)
    Collatz.runWithPrint(4).should eq([] of UInt64)
    Collatz.runWithPrint(40).should eq([4])
    Collatz.runWithPrint(53).should eq([40, 4])
    Collatz.runFast(1000).should eq(nil)
    Collatz.runWithSpecialIterationsCount(70).should eq(2)
    Collatz.runWithSpecialIterationsCount(106).should eq(1)
    Collatz.runWithSpecialIterationsCount(286).should eq(18)
  end
end
