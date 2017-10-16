# FreeDiscovery-docker

Docker setup for FreeDiscovery

## Running the container

```
docker run -it -v /shared_folder:/fd_shared -p 5001:5001  freediscovert/freediscovery 
```

where `/shared_folder` is a folder on the local system you want to share with FreeDiscovery.

To theck that FreeDiscovery server has started, run `curl  http://localhost:5001`.

See the documentation for more details

## Building the container

```
docker build -t freediscovert/freediscovery .
```

## Reporting issues

If you encounter any problems with this image please open an issue at https://github.com/FreeDiscovery/FreeDiscovery-docker
