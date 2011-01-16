# encoding: UTF-8
require File.expand_path('spec/spec_helper')

describe String19 do
  def enumerator
    RUBY_VERSION =~ /^1\.8/ ? Enumerable::Enumerator : Enumerator
  end

  it "has a VERSION" do
    String19::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "is nil for nil" do
    String19(nil).should == nil
  end

  it "is string for array" do
    String19(['a','b']).should == 'ab'
  end

  it "has correct size" do
    String19("äßáóð").size.should == 5
  end

  it "can slice" do
    String19("äßáóð").slice(1,2).should == "ßá"
  end

  it "can slice!" do
    s = String19("äßáóð")
    s.slice!(1,2).should == "ßá"
    s.should == "äóð"
  end

  it "is has an encoding" do
    String19("Ä").encoding.name.should == 'UTF-8'
  end

  it "is has a valid encoding" do
    String19("Ä").valid_encoding?.should == true
  end

  it "is a string" do
    String19('x').class.should == String
    String19('x').is_a?(String).should == true
  end

  it "can compare" do
    String19('äåé').should == 'äåé'
    String19('äåé').should == String19('äåé')
    String19('äåé').should_not == String19('aae')
    String19('äåé').should_not == 'aae'
    String19('äåé').should_not == ['äåé']
  end

  describe :to_s do
    it "returns a string19" do
      pending 'making #{} work is top priority'
      String19('äåé').to_s.size.should == 3
    end

    it "is the same" do
      pending 'making #{} work is top priority'
      a = String19('äåé')
      a.to_s.object_id.should == a.object_id
    end
  end

  describe :index do
    it "has nil index" do
      String19("bb").index('a').should == nil
    end

    it "has simple index" do
      String19("§Ð§ß").index('ß').should == 3
    end

    it "has index with offset" do
      String19("ßßÐ§ß").index('ß',2).should == 4
    end
  end

  describe :[] do
    it "has [0]" do
      ret = String19("ß§Ð§Á")[0]
      ret.should == 'ß'
      ret.size.should == 1
    end

    it "has [0..1]" do
      ret = String19("ß§Ð§Á")[0..2]
      ret.should == 'ß§Ð'
      ret.size.should == 3
    end

    it "can replace with [xxx]="
    it "can replace with [xxx..xxx]="
  end

  describe :chars do
    it "is an enumerator" do
      String19("ßä").chars.class.should == enumerator
    end

    it "has correct bytes" do
      ret = String19("ßä").chars.to_a
      ret.should == ['ß','ä']
      ret.map(&:size).should == [1,1]
    end
  end

  describe :bytes do
    it "is an enumerator" do
      String19("ßä").bytes.class.should == enumerator
    end

    it "has correct bytes" do
      String19("ßä").bytes.to_a.should == [195, 159, 195, 164]
    end
  end

  it "has bytesize" do
    String19('áßð').bytesize.should == 6
  end

  describe :respond_to? do
    it "is true for mapped methods" do
      String19('x').respond_to?(:valid_encoding?).should == true
    end

    it "is false for not mapped methods" do
      String19('x').respond_to?(:foo).should == false
    end
  end

  describe :insert do
    it "can insert at normal positions" do
      result = String19("áßð").insert(1,'áßð')
      result.should == 'ááßðßð'
      result.size.should == 6
    end

    it "can insert to negative positions" do
      result = String19("áßð").insert(-1,'áßð')
      result.should == "áßðáßð"
      result.size.should == 6
    end

    it "cannot insert outsize of string" do
      lambda{
        String19("áßð").insert(4,'áßð')
      }.should raise_error
    end
  end

  describe 'replacement' do
    it "behaves like a string" do
      "#{String19('xxx')}".should == "xxx"
    end
  end
end
