class Left
    def initialize val
        @val = val
    end

    def isLeft
        return true
    end

    def toLeft
        return @val
    end

    def isRight
        return false
    end

    def toRight
        raise "Right on left!"
    end
end

class Right
    def initialize val
        @val = val
    end

    def isLeft
        return false
    end

    def toLeft
        raise "Left on right!"
    end

    def isRight
        return true
    end

    def toRight
        return @val
    end
end