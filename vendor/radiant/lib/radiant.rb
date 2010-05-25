RADIANT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) unless defined? RADIANT_ROOT

unless defined? Radiant::Version
  module Radiant
    module Version
      Major = '0'
      Minor = '9'
      Tiny  = '0'
      Patch = 'rc3' # set to nil for normal release

      class << self
        def to_s
          [Major, Minor, Tiny, Patch].join('.')
        end
        alias :to_str :to_s
      end
    end
  end
end
