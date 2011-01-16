module String19
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  IS_18 = RUBY_VERSION =~ /^1\.8/
end

if String19::IS_18
  $KCODE = 'U' # UTF8 Mode
  require 'string19/blank_slate'
  require 'string19/encoding'

  module String19
    VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

    class Wrapper < String19::BlankSlate
      attr_reader :chars

      def initialize(wrapped)
        @chars = wrapped.scan(/./m)
      end

      def bytesize
        to_s.size
      end

      def chars
        @chars.map{|c| String19(c) }.enum_for(:each)
      end

      def encoding
        Encoding.new('UTF-8')
      end

      def class
        String
      end

      def is_a?(klass)
        [String19::Wrapper, String, Object].include?(klass)
      end

      def ==(other)
        other = other.to_s if other.is_a?(String19::Wrapper)
        other.is_a?(String) and to_s == other
      end

      def to_s
        @chars.to_s
      end

      def valid_encoding?
        true # i hope so :P
      end

      def index(what, offset=0)
        s = to_s
        offset = self[0...offset].to_s.size
        return unless found = s.index(what, offset)
        String19(s[0...found]).size
      end

      def insert(position, item)
        if position.abs > size 
          raise IndexError, "index #{position} out of string"
        end

        @chars.insert(position, *String19(item).chars.to_a)
        self
      end

      def gsub!(*args, &block)
        return unless result = to_s.send(:gsub!, *args, &block)
        @chars = result.scan(/./m)
        self
      end

      def gsub(*args, &block)
        dup.gsub!(*args, &block)
      end

      def self.wrap(*args)
        args.each do |method|
          eval("def #{method}(*args, &block); String19(@chars.#{method}(*args, &block)); end")
        end
      end

      def self.delegate(*args)
        args.each do |method|
          eval("def #{method}(*args, &block); @chars.#{method}(*args, &block); end")
        end
      end

      def self.delegate_to_s(*args)
        args.each do |method|
          eval("def #{method}(*args, &block); to_s.#{method}(*args, &block); end")
        end
      end

      wrap :dup, :slice, :slice!, :[], :inspect
      delegate :size
      delegate_to_s :match, :bytes
    end
  end
else
  module String19
    # nothing to do :P
  end
end

def String19(string)
  return string if string.nil?
  string = string.join('') if string.is_a?(Array)
  String19::IS_18 ? String19::Wrapper.new(string) : string.dup
end