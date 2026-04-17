{ config, lib, ... }:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "stalbar" ];
    ensureUsers = [
      {
        name = "stalbar";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql.wantedBy = lib.mkForce [ ];

  virtualisation.oci-containers = {
    backend = "docker";

    containers.mssql = {
      # Developer is the free SQL Server edition for local development.
      image = "mcr.microsoft.com/mssql/server:2022-latest";
      hostname = "mssql";
      ports = [ "127.0.0.1:1433:1433" ];
      volumes = [ "mssql-data:/var/opt/mssql" ];
      environment = {
        ACCEPT_EULA = "Y";
        MSSQL_PID = "Developer";
        TZ = config.time.timeZone;
      };

      # Keep the SA password out of git and out of the Nix store.
      environmentFiles = [ "/etc/mssql/server.env" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /etc/mssql 0750 root root -"
  ];

  # Avoid a failed unit before the password file exists.
  systemd.services."docker-mssql".unitConfig.ConditionPathExists = "/etc/mssql/server.env";
  systemd.services."docker-mssql".wantedBy = lib.mkForce [ ];
}
