module CrystalAV

  class ScanResult

    def initialize(result : Int32, virname : String, filename : String)
      @result = result
      @virname = virname
      @filename = filename
    end

    def virus?
      @result == LibClamAV::CL_VIRUS
    end

  end

end
