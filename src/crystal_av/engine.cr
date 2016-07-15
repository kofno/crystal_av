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

    def self.run
      engine = self.new
      begin
        engine.load
        yield engine
      ensure
        engine.close
      end
    end

    def initialize
      LibClamAV.cl_init(0)
      @engine = LibClamAV.cl_engine_new
    end

    def load
      cl_load
      cl_compile
    end

    def scan(filename)
      result = LibClamAV.cl_scanfile(
        filename,
        out virname,
        nil,
        @engine,
        LibClamAV::CL_SCAN_STDOPT
      )
      ScanResult.new(result, String.new(virname), filename)
    end

    def close
      LibClamAV.cl_engine_free(@engine)
    end

    ### Private methods

    private def cl_load
      dbpath = LibClamAV.cl_retdbdir
      signo = 0
      signo_ptr = pointerof(signo)

      LibClamAV.cl_load(dbpath, @engine, signo_ptr, LibClamAV::CL_DB_STDOPT)
    end

    private def cl_compile
      LibClamAV.cl_engine_compile(@engine)
    end

  end

end
