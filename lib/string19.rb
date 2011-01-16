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

      def chars
        @chars.map{|c| String19(c) }.enum_for(:each)
      end

      def bytesize
        to_s18.size
      end

      def bytes
        to_s18.bytes
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
        other = other.to_s18 if other.is_a?(String19::Wrapper)
        other.is_a?(String) and to_s18 == other
      end

      def to_s
        self
      end

      def to_s18
        @chars.to_s
      end

      def valid_encoding?
        true # i hope so :P
      end

      def index(what, offset=0)
        s = to_s18
        offset = self[0...offset].to_s18.size
        return unless found = s.index(what, offset)
        String19(s[0...found]).size
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

      wrap *%w[dup slice slice! []]
      delegate :size
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