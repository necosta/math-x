require "./analysis"
require "./factorization"

module Iterator
  extend self

  def iterate(maxCycles, permutations)
    counter = 0
    const = Math.log(1.5)
    genFlows(maxCycles).each_repeated_permutation(permutations) do |i|
      x_sum = i.map { |i| i[0] }.sum
      y_sum = i.map { |i| i[1] }.sum
      threshold = Math.log(2**(y_sum - x_sum)) / const
      if (x_sum < threshold)
        counter += 1
        puts i
        output = startEach(i)
        if (output > 0 && Math.isNaturalNumber?(output) && output != 4)
          puts output
          return
        end
      end
    end
    puts "#{counter} positive values"
  end

  private def startEach(input : Array(Array(Int32)))
    x = pivotInput(input, 0)
    y = pivotInput(input, 1)
    z = pivotInput(input, 2)
    w = pivotInput(input, 3)
    calc(x, y, z, w)
  end

  def calc(x, y, z, w)
    num = BigFloat.new(0)
    (1..x.size).each do |it|
      a = Analysis.getA(x, it)
      b = Analysis.getB(z, it)
      c = Analysis.getC(x, it)
      d = Analysis.getD(y, w, it)
      member = BigInt.new(2)**y.sum * Analysis.getSumMember(a, b, c, d)
      num += member
    end
    dem = BigInt.new(3)**x.sum - BigInt.new(2)**y.sum
    # Exploratory
    # numF = Math.factorize(num.abs).reject! { |v| v == 2 }.uniq
    # demF = Math.factorize(dem.abs).uniq
    # puts "Num: #{numF} || Dem: #{demF}"
    num / dem
  end

  def pivotInput(input : Array(Array(Int32)), pos)
    out = Array(Int32).new
    input.each do |array|
      out << array[pos]
    end
    out
  end

  def genFlows(maxCycles)
    flows = Array(Array(Int32)).new
    flows << [1, 2, 1, 0]
    flows << [1, 4, 1, 0]
    (0..maxCycles).each do |x|
      flows << [x, x + 6, x, x + 1]
      flows << [x + 1, x + 6, x, x + 1]
      flows << [x + 1, x + 5, x + 1, x + 2]
      flows << [x + 2, x + 5, x + 1, x + 2]
      flows << [x + 1, x + 3, x + 1, x + 2]
      flows << [x + 2, x + 3, x + 1, x + 2]
    end
    flows
  end
end
