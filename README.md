# procto

Method objects. CoverHound wanted to specify method names sometimes, so we spun
this off.

## Usage

```ruby
require 'procto'

class Greeter
  include Procto.call

  def initialize(text)
    @text = text
  end

  def call
    "Hello #{text}"
  end
  
  private
  attr_reader :text
end

Greeter.call('world') # => "Hello world"

class Printer
  include Procto.call(:print)

  def initialize(text)
    @text = text
  end

  def print
    "Hello #{text}"
  end

  private
  attr_reader :text
end

Printer.print('world') # => "Hello world"
```

## Credits

* [snusnu](https://github.com/snusnu)
* [mbj](https://github.com/mbj)
* [supernats](https://github.com/supernats)

## Copyright

Copyright &copy; 2026 CoverHound. See [LICENSE](LICENSE) for details.
