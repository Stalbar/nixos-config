{ pkgs, ... }:

{
  services.neo4j = {
    enable = true;
    package = pkgs.neo4j;

    # Keep the database reachable only from the local machine by default.
    defaultListenAddress = "127.0.0.1";

    http = {
      enable = true;
      listenAddress = "127.0.0.1:7474";
    };

    bolt = {
      enable = true;
      listenAddress = "127.0.0.1:7687";
    };

    https.enable = false;
  };
}
