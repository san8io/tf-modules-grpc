# setup

FastAPI + gRPC client app:

```
python -m pip install virtualenv
virtualenv venv
source venv/bin/activate
python -m pip install --upgrade setuptools
python -m pip install --upgrade pip
```

Docker image:
```
docker build -t client-app .
docker run -d --name client-app -p 80:80 client-app
```