module Babl
  class ModuleResponse
    attr_reader :exitcode, :payload_url

    def initialize response
      @stdout_raw = response["Stdout"]
      @stderr_raw = response["Stderr"]
      @exitcode = response["Exitcode"]

      @payload_url = response["PayloadUrl"]
    end

    def stdout allow_fetch = true
      @stdout ||= begin
        if payload_url.to_s != ""
          fetch_payload if allow_fetch
        else
          o = Base64.decode64(@stdout_raw)
          @stdout_raw = nil
          o
        end
      end
    end

    def stderr
      @stderr ||= begin
        o = Base64.decode64(@stderr_raw)
        @stderr_raw = nil
        o
      end
    end

    def fetch_payload
      if payload_url.to_s != ""
        Net::HTTP.get URI(payload_url)
      end
    end
  end
end