require File.expand_path('spec/spec_helper')

describe String19 do
  it "has a VERSION" do
    String19::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
