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

### Test

1. Go to the manager interface:

  http://localhost/manager/
2. Login with:
  - Username: tomcat
  - Password: tomcat
