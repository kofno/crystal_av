module CrystalAV

  # Engine wraps up lower level ClamAV calls in an object. This class
  # manages those details to create a simplified interface. Instances of this
  # class are expected to be long lived, since loading and compiling an engine
  # is expensive (6 seconds on this machine).
  #
  # Calling Engine.run ensures that the AV Engine resources are freed when
  # virus scanning operations are completed.
  #
  class Engine

    extend CHandler
    include CHandler

    def self.run
      engine = self.new
      begin
        engine.load
        yield engine
      ensure
        engine.close
      end
    end

    def self.load
      c_err_handler { LibClamAV.cl_init(0) }
      engine = c_nil_handler("Failed to allocate engine") {
        LibClamAV.cl_engine_new
      }
      c_err_handler { load_db_files(engine) }
      c_err_handler { compile_db(engine) }
      new(engine)
    end

    def self.load
      engine = load
      yield engine ensure engine.close
    end

    private def self.load_db_files(engine)
      dbpath = LibClamAV.cl_retdbdir
      signo = 0
      signo_ptr = pointerof(signo)

      LibClamAV.cl_load(dbpath, engine, signo_ptr, LibClamAV::CL_DB_STDOPT)
    end

    private def self.compile_db(engine)
      LibClamAV.cl_engine_compile(engine)
    end

    private def initialize(engine : Pointer(LibClamAV::Engine))
      @engine = engine
    end

    def scan(filename)
      result = LibClamAV.cl_scanfile(
        filename,
        out virname,
        nil,
        @engine,
        LibClamAV::CL_SCAN_STDOPT
      )

      ScanResult.new(result, virname, filename)
    end

    def close
      c_err_handler { LibClamAV.cl_engine_free(@engine) }
    end

  end

end
