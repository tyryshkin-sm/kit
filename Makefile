# ansible

build.ansible.image: registry ?= sovitsky
build.ansible.image: version ?= 8.2.0
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
build.terraform.image: version ?= 1.5.5
build.terraform.image:
	docker build \
		--file automation/terraform/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/terraform:${version} \
		automation/terraform/
	docker push ${registry}/terraform:${version}

build.terraform.binary: version ?= 1.5.5
build.terraform.binary:
	docker build \
		--file automation/terraform/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		automation/terraform/

# kubectl

build.kubectl.image: registry ?= sovitsky
build.kubectl.image: version ?= 1.28.0
build.kubectl.image:
	docker build \
		--file automation/kubectl/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/kubectl:${version} \
		automation/kubectl/
	docker push ${registry}/kubectl:${version}

build.kubectl.binary: version ?= 1.28.0
build.kubectl.binary:
	docker build \
		--file automation/kubectl/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		automation/kubectl/

# helm

build.helm.image: registry ?= sovitsky
build.helm.image: version ?= 3.12.3
build.helm.image:
	docker build \
		--file automation/helm/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/helm:${version} \
		automation/helm/
	docker push ${registry}/helm:${version}

build.helm.binary: version ?= 3.12.3
build.helm.binary:
	docker build \
		--file automation/helm/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		automation/helm/

# hadolint

build.hadolint.binary: version ?= latest
build.hadolint.binary:
	docker build \
		--file linter/hadolint/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		linter/hadolint/

# k6

build.k6.image: registry ?= sovitsky
build.k6.image: version ?= 0.46.0
build.k6.image:
	docker build \
		--file load/k6/Dockerfile \
		--build-arg VERSION=${version} \
		--target image \
		--tag ${registry}/k6:${version} \
		load/k6/
	docker push ${registry}/k6:${version}

build.k6.binary: version ?= 0.46.0
build.k6.binary:
	docker build \
		--file load/k6/Dockerfile \
		--build-arg VERSION=${version} \
		--output output \
		--target output \
		load/k6/

# cooker

build.cooker.image: registry ?= sovitsky
build.cooker.image: packer_version ?= 1.9.2
build.cooker.image: ansible_version ?= 8.3.0
build.cooker.image: cooker_version ?= latest
build.cooker.image: network ?= host
build.cooker.image:
	docker build \
		--file cooker/Dockerfile \
		--build-arg PACKER_VERSION=${packer_version} \
		--build-arg ANSIBLE_VERSION=${ansible_version} \
		--tag ${registry}/cooker:${cooker_version} \
		cooker/

	docker push ${registry}/cooker:${cooker_version}
