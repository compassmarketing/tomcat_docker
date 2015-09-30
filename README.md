# tomcat_docker

### Build

To build, just run docker build:

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

1. Go to the manager interface:

  http://localhost/manager/
2. Login with:
  - Username: tomcat
  - Password: tomcat
