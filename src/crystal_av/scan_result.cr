module CrystalAV

  class ScanResult

    getter :virname
    getter :filename
    private getter :result

    def initialize(result : Int32, virname : String, filename : String)
      @result = result
      @virname = virname
      @filename = filename
    end

    def virus?
      @result == LibClamAV::CL_VIRUS
    end

    def clean?
      @result == LibClamAV::CL_CLEAN
    end

    def error?
      !virus? && !clean?
    end

    def error_message
      return "" unless error?
      lookup_err_msg(result)
    end

    private def lookup_err_msg(code : Int32)
      String.new(LibClamAV.cl_strerror(code))
    end

  end

end
