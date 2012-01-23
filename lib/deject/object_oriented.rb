def Deject(klass)
  klass.extend Deject
end

module Deject
  UninitializedDependency = Class.new StandardError

  def dependency(meth, &block)
    InstanceMethods.new self, meth, block
  end

  class InstanceMethods
    attr_accessor :klass, :meth, :initializer, :ivar

    def initialize(klass, meth, initializer)
      self.klass, self.meth, self.initializer, self.ivar = klass, meth, initializer, "@#{meth}"
      define_getter
      define_override
      define_multi_override
    end

    def define_getter
      ivar, meth, initializer = self.ivar, self.meth, self.initializer
      klass.send :define_method, meth do
        unless instance_variable_defined? ivar
          instance_variable_set ivar, Deject::Dependency.new(self, meth, initializer)
        end
        instance_variable_get(ivar).invoke
      end
    end

    def define_override
      ivar, meth = self.ivar, self.meth
      klass.send :define_method, "with_#{meth}" do |value=nil, &initializer|
        initializer ||= Proc.new { value }
        instance_variable_set ivar, Deject::Dependency.new(self, meth, initializer)
        self
      end
    end

    def define_multi_override
      klass.send :define_method, :with_dependencies do |overrides|
        overrides.each { |meth, value| send "with_#{meth}", value }
        self
      end
    end
  end

  class Dependency < Struct.new(:instance, :dependency, :initializer)
    attr_accessor :result

    def invoke
      validate_initializer!
      memoized_result
    end

    def validate_initializer!
      return if initializer
      raise UninitializedDependency, "#{dependency} invoked before being defined"
    end

    def memoized_result
      memoize! unless memoized?
      result
    end

    def memoized?
      @memoized
    end

    def memoize!
      @memoized = true
      self.result = instance.instance_eval &initializer
    end
  end
end

