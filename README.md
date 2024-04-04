# Simetrik

## Project structure
- `client/` folder contains a gRPC + HTTP client.
- `server/` folder contains a gRPC server.
- `infra/` folder contains the infrastructure stack (EKS cluster with custom local modules).
- `docker-compose.yml` file contains docker stack configuration for local testing.
  
## App development setup
Install a Python version manager like [pyenv](https://github.com/pyenv/pyenv) for Mac OS X:
```
brew update
brew install pyenv
```
Configure pyenv for your shell e.g. zsh:
```
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

Install Python build dependencies:
- Xcode Command Line Tools (xcode-select --install) and Homebrew should be already installed, then:
```
brew install openssl readline sqlite3 xz zlib tcl-tk
```

Install Python version 3.12.2 and use it in current local directory:
```
pyenv install 3.12
pyenv local 3.12
```

Install Python package manager and dependencies:
```
python -m pip install --upgrade setuptools
python -m pip install --upgrade pip
```

Install a Python virtual environment tool:
```
python -m pip install virtualenv

# restart your shell for the PATH changes to take effect
exec "$SHELL"

source venv/bin/activate
python -m pip install --upgrade setuptools
python -m pip install --upgrade pip
```

Install gRPC and gRPC tools:
```
python -m pip install grpcio
python -m pip install grpcio-tools
```

