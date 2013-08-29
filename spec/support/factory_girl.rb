#require 'spec/support/factory_girl/shams'

# Convenience method that requires all defined factories.
#
# Not needed in the test suite, where factories are required automatically, but
# useful for interactive consoles.
#
# Note that FactoryGirl itself has an almost equivalent `#find_definitions`
# method, but it's non-documented internal API, so we don't rely on it.
#def FactoryGirl.require!
  #Dir['spec/factories/**/*.rb'].each do |factory|
    #begin
      #require factory.sub(/\.rb\z/, '')
    #rescue FactoryGirl::DuplicateDefinitionError
      ## gracefully handle duplicative require statements
    #end
  #end
#end

# Convenience methods added to invoke Factory Girl factories by sending
# messages directly to ActiveRecord classes.
#
# We use these rather than the one provided by Factory Girl itself
# (factory_girl/syntax/make) because we want wrappers for all four methods,
# not just "create", and we also want the option of customising the returned
# instance via a block.
class ActiveRecord::Base
  class << self

    # Wrapper for FactoryGirl.build
    def make(*args, &block)
      make_with(name.underscore, *args, &block)
    end

    # Like #make, but allows the caller to explicitly specify a factory name.
    def make_with(factory_name, *args, &block)
      factory_girl_delegate :build, factory_name, *args, &block
    end

    # Wrapper for FactoryGirl.build_list
    def make_list(count, *args, &block)
      factory_girl_delegate :build_list, name.underscore, count, *args, &block
    end

    # Wrapper for FactoryGirl.create
    def make!(*args, &block)
      make_with!(name.underscore, *args, &block)
    end

    # Like #make!, but allows the caller to explicitly specify a factory name.
    def make_with!(factory_name, *args, &block)
      factory_girl_delegate :create, factory_name, *args, &block
    end

    # Wrapper for FactoryGirl.build_list
    def make_list!(count, *args, &block)
      factory_girl_delegate :create_list, name.underscore, count, *args, &block
    end

    # Wrapper for FactoryGirl.attributes_for
    def valid_attributes(*args, &block)
      valid_attributes_with(name.underscore, *args, &block)
    end

    # Like #valid_attributes, but allows the caller to explicitly specify a
    # factory name.
    def valid_attributes_with(factory_name, *args, &block)
      factory_girl_delegate :attributes_for, factory_name, *args, &block
    end

    # Wrapper for FactoryGirl.build_stubbed
    def stub(*args, &block)
      stub_with(name.underscore, *args, &block)
    end

    # Like #stub, but allows the caller to explicitly specify a factory name.
    def stub_with(factory_name, *args, &block)
      factory_girl_delegate :build_stubbed, factory_name, *args, &block
    end

  private

    def factory_girl_delegate(method, factory_name, *args, &block)
      object = FactoryGirl.send method, factory_name, *args
      yield object if block_given?
      object
    end
  end
end
