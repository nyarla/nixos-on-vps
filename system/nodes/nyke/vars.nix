let
  localhost = "127.0.0.1";
  internal = "100.72.114.65";
  listen =
    {
      domain,
      addr,
      port,
    }@args:
    args
    // {
      listen = "${addr}:${toString port}";
      http = "http://${domain}";
      https = "https://${domain}";
    };
in
{
  inherit listen;

  # Public services
  # ===============
  # port 1xx80 -> internal
  # port 2xx80 -> public connection
  gotosocial =
    let
      domain = "kalaclista.com";
    in
    {
      app = listen {
        inherit domain;
        addr = localhost;
        port = 10080;
      };

      endpoint = listen {
        inherit domain;
        addr = localhost;
        port = 20080;
      };
    };

  pixelfed =
    let
      domain = "px.kalaclista.com";
    in
    {
      endpoint = listen {
        inherit domain;
        addr = localhost;
        port = 20180;
      };
    };

  albyhub =
    let
      domain = "albyhub.thotep.net";
    in
    {
      endpoint = listen {
        inherit domain;
        addr = localhost;
        port = 29080;
      };
    };

  # Private services
  # ================
  # port 3xx80 -> internal port
  # port 4xx80 -> public connection
  searx =
    let
      domain = "search.nyke.server.thotep.net";
    in
    {
      app = listen {
        inherit domain;
        addr = localhost;
        port = 30080;
      };

      endpoint = listen {
        inherit domain;
        addr = internal;
        port = 40080;
      };
    };

  freshrss =
    let
      domain = "reader.nyke.server.thotep.net";
    in
    {
      endpoint = listen {
        inherit domain;
        addr = internal;
        port = 40280;
      };
    };
}
