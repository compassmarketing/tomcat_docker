# tomcat_docker

### Notes

Shell patches should only use the variables `COMPASS_SAP_SOURCES_DIR` and `COMPASS_SAP_INSTALL_DIR` for portability.

### Build

1. Check the following variables in `install/sap-install-Tomcat.sh` and make sure the remote sources are available, if used  *HTTP fetching is used*:
  - `COMPASS_SAP_IPS_SOURCE`
  - `COMPASS_SAP_IPS_SP_SOURCE`
  - `COMPASS_SAP_IPS_PATCH_SOURCE`
  - `COMPASS_SAP_DS_SOURCE`
  - `COMPASS_SAP_DS_SP_SOURCE`
  - `COMPASS_SAP_DS_PATCH_SOURCE`
2. Select the correct SAP auto-instalation configurations by setting the following variables in `install/sap-install-Tomcat.sh`.  Service pack and patch autoinstalls should use the same, default, file.
  - `COMPASS_SAP_IPS_AUTOINSTALL`
  - `COMPASS_SAP_SP_AUTOINSTALL`
  - `COMPASS_SAP_PATCH_AUTOINSTALL`
  - `COMPASS_SAP_DS_AUTOINSTALL`
  - `COMPASS_SAP_DS_SP_AUTOINSTALL`
  - `COMPASS_SAP_DS_PATCH_AUTOINSTALL`
3. Start an IPS instance
4. Configure the `COMPASS_SAP_IPS_AUTOINSTALL` file to connect to it during the build process
5. Build:

  ```console
  docker build -t tomcat_docker .
  ```

### Run

To run:

```console
docker run -d --net=host --name=tomcat tomcat_docker
```

A normal container exit status after a `docker stop` is 143 (128 + 15).

If tomcat had to be KILLed by `docker`, the exit code is 137 (128 + 9).

### Test

1. Start the container.
2. Connect to ips.

### Known issues

- Patches modifying dataservices/bin/dsodbcdb_env.sh will fail.  This is normal and does not affect the building of the container.
- /opt/sap/sap_bobj/enterprise_xi40/java/lib/im/mysql/': No such file or directory is normal.