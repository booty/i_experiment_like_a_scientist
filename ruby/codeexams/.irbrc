IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:HISTORY_FILE] = File.expand_path("~/.irb_history")

class Jb
  def self.a
    [1, 2, 3, 4, 5]
  end

  def self.h
    { a: 1, b: 2, c: 3, d: 4, e: 5 }
  end

  def self.aliases
    IRB.conf[:COMMAND_ALIASES]
  end
end

if (pp_successful = require "pp")
  IRB.conf[:INSPECT_MODE] = :pp
end

def cl
  system("clear")
end

class Object
  def jbmeth(obj = self)
    (obj.methods - obj.class.superclass.methods).sort
  end

  def jbmethpub(obj = self)
    (obj.public_methods - obj.class.superclass.methods).sort
  end

  def jbmethpriv(obj = self)
    (obj.public_methods - obj.class.superclass.methods).sort
  end
end

IRB.conf[:COMMAND_ALIASES].merge!({
                                    b: :backtrace,
                                    c: :continue,
                                    e: :edit,
                                    l: :ls,
                                    n: :next,
                                    s: :step,
                                    w: :whereami # Shows where you are in the code
                                  })

ircrb_path = begin
  Pathname.new(__FILE__).relative_path_from(Pathname.pwd).to_s
rescue ArgumentError
  __FILE__
end
puts "#{ircrb_path} loaded (pretty_print:#{pp_successful ? 'yep' : 'nope'})"
