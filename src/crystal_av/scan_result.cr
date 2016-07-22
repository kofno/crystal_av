module CrystalAV

  class ScanResult

    getter :filename
    private getter :result
    private getter :virname

    def initialize(result : Int32, virname : UInt8*, filename : String)
      @result = result
      @virname = virname
      @filename = filename
    end

    def virus?
      @result == LibClamAV::CL_VIRUS
    end

    def virus_name
      virus? ? String.new(virname) : ""
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
