Stop thinking about differences between 1.9 and 1.8.

size / index / slice / slice! / chars / bytes / [] etc supported

Still some methods missing, fork & pull for what you need!


Install
=======
    sudo gem install string19

Usage
=====
    # on 1.8 AND 1.9
    String19("Á§ÐÁ§Ð").size == 6

    # to add a new wrapped method (result is a String19)
    class String
      def foo
        'fäää'
      end
    end

    String19::Wrapped.wrap(:foo) if String19::IS_19
    String19('').foo.size == 4

    # to add a new delegated method (result is not modified)
    class String
      def foo
        42
      end
    end

    String19::Wrapped.delegate(:foo) if String19::IS_19

    String19('').foo == 42

Author
======
[Michael Grosser](http://grosser.it)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...
