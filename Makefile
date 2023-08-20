# ansible

build.ansible.image: registry ?= sovitsky
build.ansible.image: version ?= latest
build.ansible.image:
	docker build \
		--file automation/ansible/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/ansible:${version} \
		automation/ansible/
	docker push ${registry}/ansible:${version}

# terraform

build.terraform.image: registry ?= sovitsky
build.terraform.image: version ?= latest
build.terraform.image:
	docker build \
		--file automation/terraform/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/terraform:${version} \
		automation/terraform/
	docker push ${registry}/terraform:${version}

build.terraform.binary: version ?= latest
build.terraform.binary:
	docker build \
		--file automation/terraform/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		automation/terraform/

# kubectl

build.kubectl.image: registry ?= sovitsky
build.kubectl.image: version ?= latest
build.kubectl.image:
	docker build \
		--file automation/kubectl/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/kubectl:${version} \
		automation/kubectl/
	docker push ${registry}/kubectl:${version}

build.kubectl.binary: version ?= latest
build.kubectl.binary:
	docker build \
		--file automation/kubectl/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		automation/kubectl/

# helm

build.helm.image: registry ?= sovitsky
build.helm.image: version ?= latest
build.helm.image:
	docker build \
		--file automation/helm/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/helm:${version} \
		automation/helm/
	docker push ${registry}/helm:${version}

build.helm.binary: version ?= latest
build.helm.binary:
	docker build \
		--file automation/helm/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		automation/helm/
