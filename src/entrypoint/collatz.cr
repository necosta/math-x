require "option_parser"
require "big"
require "../collatz"
require "../iterator"
require "../math"

BigFloat.default_precision = 128

enum Option
  RunOnce         # 0
  RunUpwards      # 1
  RunLoopAnalysis # 2
  RunSpecial      # 3
end

option = Option::RunOnce
value = 1634

OptionParser.parse! do |parser|
  parser.banner = "Usage:"
  parser.on("-o option", "--option option", "Select a running option:
      RunOnce - Applies algorithm to a single value
      RunUpwards - Applies algorithm infinitely staring from an initial value
      RunLoopAnalysis - Checks for possible 'loop' solutions
      RunSpecial - Applies algorithm to long k-iterations
    ") { |opt| option = Option.parse(opt) }
  parser.on("-v value", "--value value", "Set a value:
    RunOnce - Single value
    RunUpwards - Starting value
    RunLoopAnalysis - Number of permutations
    RunSpecial - Number of long k-iterations
    ") do |v|
    raise ArgumentError.new("Value must be positive") if v.to_i < 0
    value = BigInt.new(v)
  end
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option"
    STDERR.puts parser
    exit(1)
  end
end

case option
when Option::RunOnce
  puts "Returning Collatz sequence for value #{value}:"
  Collatz.runWithPrint(value).each do |o|
    puts "#{o[1]} -> #{o[0]}"
  end
when Option::RunUpwards
  puts "Running Collatz algorithm infinitely starting at value #{value}:"
  input = BigInt.new(value)
  iter = 0
  step = 1024 * 10 # Step to print status
  while true
    if (iter == step)
      puts input
      iter = 0
    end
    Collatz.runFast(input)
    input += 18
    iter += 1
  end
when Option::RunLoopAnalysis
  kcycles = 15 # ToDo: Soft-code this value...
  permutations = value
  puts "Running loop analysis for #{kcycles} k-cycles(s) and #{permutations} permutation(s)"
  # ToDo: Add permutations with repeated values
  iterations = Iterator.genAggFlows(kcycles, permutations)
  iter_size = iterations.size
  raise ArgumentError.new("Permutations exceed iterations") if permutations > iter_size
  puts "Number of permutations: #{iter_size}"
  iterations.each do |i|
    output = Iterator.start(i)
    if (Math.isWholeNumber?(output) && output != 0)
      puts i
      puts output
    end
  end
  puts "Finished finding solutions for #{iter_size} permutations"
when Option::RunSpecial
  exp = value
  input = (BigInt.new(2)**exp - 1)*18 + 16
  puts "Returning Collatz sequence for special value with #{exp} k-iterations:"
  out = Collatz.runWithPrint(input)
  out.first(3).each do |o|
    puts "#{o[1]} -> #{o[0]}"
  end
  puts "..."
  out.last(3).each do |o|
    puts "#{o[1]} -> #{o[0]}"
  end
end