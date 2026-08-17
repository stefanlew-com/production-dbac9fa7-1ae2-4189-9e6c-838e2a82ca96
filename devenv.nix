{ pkgs, ... }:
{
  packages = [ pkgs.git ];

  scripts.deploy.exec = ''
    echo "Nothing to deploy yet"
  '';
}
