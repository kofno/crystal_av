module CrystalAV

  module CHandler

    def c_err_handler
      result = yield
      if result != LibClamAV::CL_SUCCESS
        err_msg = String.new(LibClamAV.cl_strerror(result))
        raise err_msg
      end
      result
    end

    def c_nil_handler(err_msg)
      result = yield
      raise err_msg if result.is_a?(Nil) || result.null?
      result
    end

  end

end
