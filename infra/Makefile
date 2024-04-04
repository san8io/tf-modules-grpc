# Pre-requisites validation
EXECUTABLES = terraform aws
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH")))
TMP := $(shell mkdir -p .tmp)
TMP_PATH = ./.tmp

.PHONY: init
init:
	{ \
	set -e ;\
	terraform init -no-color ;\
	} 2>&1 | tee -a "${TMP_PATH}/init.log" ;

.PHONY: validate
validate:
	{ \
	set -e ;\
	terraform fmt -no-color ;\
	terraform validate -no-color ;\
	terraform plan -no-color ;\
	} 2>&1 | tee -a "${TMP_PATH}/validate.log" ;

.PHONY: apply
apply:
	{ \
	set -e ;\
	terraform apply -no-color -auto-approve ;\
	} 2>&1 | tee -a "${TMP_PATH}/apply.log" ;

.PHONY: upgrade
upgrade:
	{ \
	set -e ;\
	terraform init -no-color -upgrade ;\
	terraform providers lock \
		-platform=windows_amd64 \
		-platform=darwin_amd64 \
		-platform=linux_amd64 \
		-platform=darwin_arm64 \
		-platform=linux_arm64 \
		-no-color ;\
	} 2>&1 | tee -a "${TMP_PATH}/upgrade.log" ;

.PHONY: clean
clean:
	rm  -rf ./*.log ./**/*.log ${TMP_PATH} ;