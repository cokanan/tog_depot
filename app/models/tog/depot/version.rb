module Version
  MAJOR = 0
  MINOR = 4
  TINY  = 2
  MODULE = "tog_depot"
  STRING = [MAJOR, MINOR, TINY].join('.')

  class << self
    def to_s
      STRING
    end
    def full_version
      "#{MODULE} #{STRING}"
    end
    alias :to_str :to_s
  end
end
