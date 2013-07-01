
Lego::Run::Chain.new.
  bind(  ->(val){ Lego.right(val + 42) } ).
  bind(  ->(val){ Lego.right(val + 24) } ).
  chain( ->     { Lego.right('OK') })


Lego.pass
Lego.fail


Lego.execute{ |val| Lego.pass(val + 42) }   # only execute block if input was Lego.pass




Lego::Run::CollectErrors.new.
  chain( ->{ Lego.right(val + 42) } ).
  chain( ->{ Lego.right(val + 24) } ).
  chain( ->{ Lego.right('OK') })
