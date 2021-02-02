{ pkgs, ... }:

let
  database_secrets = import ./database_secrets.nix;
in
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    port = 5432;

      #host all all ::1/128 trust
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 0.0.0.0/0 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE postgres_user WITH LOGIN PASSWORD '${database_secrets.website_password}' CREATEDB;
      CREATE DATABASE website;
      GRANT ALL PRIVILEGES ON DATABASE website TO postgres_user;
    '';


    # Ensure the database, user, and permissions always exist
    ensureDatabases = [ "website" ];
    ensureUsers = [
      { name = "postgres_user";
        ensurePermissions."DATABASE website" = "ALL PRIVILEGES";
      }
    ];
  };
}
