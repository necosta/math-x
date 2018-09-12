require "option_parser"
require "big/big_int"
require "../collatz"
require "../iterator"
require "../math"

enum Option
  RunOnce         # 0
  RunUpwards      # 1
  RunLoopAnalysis # 2
  RunSpecial      # 3
end

option = Option::RunOnce
value = 100

OptionParser.parse! do |parser|
  parser.banner = "Usage:"
  parser.on("-o option", "--option option", "Select a running option:
      RunOnce - Apply algorithm to a single value
      RunUpwards - Apply algorithm infinitely staring from an initial value
      RunLoopAnalysis - Check for possible solutions for 'loop' equation
      RunSpecial - Explores long 7EVEN-8ODD-7EVEN iterations
    ") { |opt| option = Option.parse(opt) }
  parser.on("-v value", "--value value", "Set a value:
    RunOnce - Single value
    RunUpwards - Starting iteration value
    RunLoopAnalysis - Number of kcycles
    RunSpecial - Number of 'long' iterations
    ") { |v| value = v.to_i }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option"
    STDERR.puts parser
    exit(1)
  end
end

case option
when Option::RunOnce
  puts "Running Collatz for value #{value}"
  sysout = Collatz.runWithPrint(value.to_u64)
  sysout.each do |o|
    puts o
  end
when Option::RunUpwards
  puts "Running Collatz starting at value #{value}"
  input = BigInt.new(value)
  while true
    puts "Value: #{input}"
    sysout = Collatz.runWithPrint(input)
    sysout.each do |o|
      puts o
    end
    input = input + 18
  end
when Option::RunLoopAnalysis
  kcycles = value
  # Will iterate through permutations but will never finish given the high number of permutations
  permutations = 20
  (1..permutations).each do |p|
    puts "Running loop analysis for #{kcycles} k-cycles(s) and #{p} permutation(s)"
    Math.genComplexInput(kcycles, p).each do |i|
      temp = Math.iter(i)
      if (Math.isWholeNumber?(temp) && temp > 0)
        puts i
        puts temp
      end
    end
  end
when Option::RunSpecial
  (1..value).each do |p|
    input = (BigInt.new(2)**p - 1)*18 + 16
    puts "Running Collatz for special value #{input}"
    puts Collatz.runWithSpecialIterationsCount(input)
  end
end
