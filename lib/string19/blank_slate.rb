module String19
  class BlankSlate
    instance_methods.each { |m| undef_method m unless m =~ /^(__|instance_|should|respond_to\?)/ }
  end
end