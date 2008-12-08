class Either
  def isLeft; false; end
  def isRight; false; end
  def left; raise "left on right!"; end
  def right; raise "right on left!"; end

  def self.leftIf bool, left, right
    bool ? Left.new(left) : Right.new(right)
  end  
end

class Left < Either
  def initialize val; @val = val; end
  def isLeft; true; end
  def left; @val; end
end

class Right < Either
  def initialize val; @val = val; end
  def isRight; true; end
  def right; @val; end
end