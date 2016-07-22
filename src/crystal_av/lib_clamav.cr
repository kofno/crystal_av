module CrystalAV

  @[Link("libclamav")]
  lib LibClamAV

    CL_SUCCESS = 0

    ### results
    CL_CLEAN = 0
    CL_VIRUS = 1

    ### DB Options
    CL_DB_PHISHING = 0x2
    CL_DB_PHISHING_URLS = 0x8
    CL_DB_STDOPT = CL_DB_PHISHING | CL_DB_PHISHING_URLS

    ### Scan Options
    CL_SCAN_RAW = 0x0
    CL_SCAN_ARCHIVE = 0x1
    CL_SCAN_MAIL = 0x2
    CL_SCAN_OLE2 = 0x4
    CL_SCAN_BLOCKENCRYPTED = 0x8
    CL_SCAN_HTML = 0x10
    CL_SCAN_PE = 0x20
    CL_SCAN_BLOCKBROKEN = 0x40
    CL_SCAN_MAILURL = 0x80
    CL_SCAN_BLOCKMAX = 0x100
    CL_SCAN_ALGORITHMIC = 0x200
    CL_SCAN_PHISHING_DOMAINLIST = 0x400
    CL_SCAN_PHISHING_BLOCKSSL = 0x800    # ssl mismatches, not ssl by itself
    CL_SCAN_PHISHING_BLOCKCLOAK = 0x1000
    CL_SCAN_ELF = 0x2000
    CL_SCAN_PDF = 0x4000
    CL_SCAN_STDOPT =
      CL_SCAN_ARCHIVE |
      CL_SCAN_MAIL |
      CL_SCAN_OLE2 |
      CL_SCAN_HTML |
      CL_SCAN_PE |
      CL_SCAN_ALGORITHMIC |
      CL_SCAN_ELF |
      CL_SCAN_PHISHING_DOMAINLIST

    struct Engine
      refcount : UInt32
      sbd : UInt16
      dboptions : UInt32

      root : Void**

      md5_hlist : Void**
      md5_sect  : Void*

      zip_mlist : Void*

      rar_mlist : Void*

      whitelist_matcher : Void*
      domainlist_matcher : Void*
      phishcheck : Void*

      dconf : Void*

    end

    ### Functions and stuff

    fun cl_init(options : UInt32) : Int32
    fun cl_engine_new : Pointer(Engine)
    fun cl_engine_free(engine : Pointer(Engine)) : Int32
    fun cl_retdbdir : UInt8*  # C String
    fun cl_load(
      path : UInt8*, engine : Engine*, signo : Int32*, options : UInt32
    ) : Int32
    fun cl_engine_compile(engine : Engine*) : Int32
    fun cl_scanfile(
      filename : UInt8*,
      virname : UInt8**,
      scanned : UInt64*,
      engine : Engine*,
      options : UInt32
    ) : Int32
    fun cl_strerror(errcode : Int32) : UInt8*

  end
end
