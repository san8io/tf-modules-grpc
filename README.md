# Simetrik

## Architecture diagrams

- [Network diagram](./diagrams/network_diagram.png)
- [Systems diagram](./diagrams/systems_diagram.png)

## Project structure
- `client/` folder contains a gRPC + HTTP client.
- `server/` folder contains a gRPC server.
- `infra/` folder contains the infrastructure stack (EKS cluster with custom local modules).
- `protos/` folder contains protocol buffers data models.
- `grpc_compiled/` folder contains the proto compiler output.
- `docker-compose.yml` file contains docker stack configuration for local testing.
- `diagrams/` folder contains the infrastructure and network physical and logical diagrams.
  
## App development setup
Follow these steps for Python application development:

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

For further instructions visit apps' README.md files:
- [Client's README.md](./client/README.md)
- [Server's README.md](./server/README.md)

## Infra development setup
Follow these steps for Terraform infrastructure as code development:

Install a terraform version manager like [tfenv](https://github.com/tfutils/tfenv) for Mac OS X:
```
brew update
brew install tfenv
```

Configure pyenv for your shell e.g. zsh:
```
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zprofile
```

Install Terraform latest version and use it in your local directory:
```
tfenv install 1.7.5
tfenv use 1.7.5
```

For further instructions visit infra's README.md file:
- [Infra's README.md](./infra/README.md)