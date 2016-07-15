# crystal_av

ClamAV bindings for Crystal.

## Installation

You'll need ClamAV installed.

On OS X:

```
$> brew update
$> brew install clamav
```

TODO: Installation instructions for other operation systems.

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crystal_av:
    github: kofno/crystal_av
```


## Usage

Before you can use ClamAV, you'll need to run the `freshclam` utility. This
installs (or updates) the ClamAV database.

```crystal
require "crystal_av"
```

From here, you can use the low level bindings directly.

```crystal

include CrystalAV

puts LibClamAV.cl_init(0)

engine = LibClamAV.cl_engine_new
puts engine
puts typeof(engine)

dbpath = LibClamAV.cl_retdbdir
puts String.new(dbpath)

signo = 0
signo_ptr = pointerof(signo)

puts LibClamAV.cl_load(dbpath, engine, signo_ptr, LibClamAV::CL_DB_STDOPT)
puts LibClamAV.cl_engine_compile(engine)

puts LibClamAV.cl_scanfile(
  "/Users/you/Downloads/clamdoc.pdf",
  out not_a_virus,
  nil,
  engine,
  LibClamAV::CL_SCAN_STDOPT
)

puts LibClamAV.cl_scanfile(
  "/Users/you/Downloads/example_virus.txt",
  out virname,
  nil,
  engine,
  LibClamAV::CL_SCAN_STDOPT
)
puts String.new(virname)

puts LibClamAV.cl_engine_free(engine)

```

TODO: Document bindings wrapper.


## Contributing

1. Fork it ( https://github.com/kofno/crystal_av/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [kofno](https://github.com/kofno) Ryan L. Bell - creator, maintainer
