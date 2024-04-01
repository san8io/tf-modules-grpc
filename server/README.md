# setup

gRPC server app:

```
python -m pip install virtualenv
virtualenv venv
source venv/bin/activate
python -m pip install --upgrade setuptools
python -m pip install --upgrade pip
```

Docker image:
```
docker build -t server-grpc .
docker run -d --name server-grpc -p 50051:50051 server-grpc
```