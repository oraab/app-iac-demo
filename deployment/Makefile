RELEASE_NAME := $(shell git --no-pager log -1 --format=v%ad-%h --date=format:'%Y%m%d-%H%M%S')
TAG_NAME := $(ENVIRONMENT)-images:$(RELEASE_NAME)

.PHONY: build-infra build push 

build-infra:
	chmod 755 build_infra.sh
	$(eval ENVIRONMENT := $$ENVIRONMENT)
	$(eval DOMAIN_NAME := $$DOMAIN_NAME)
	./build_infra.sh ${ENVIRONMENT} ${DOMAIN_NAME}

build:
	$(eval APP_NAME := $$APP_NAME)
	docker build ../code/. --file ../code/Dockerfile -t ${APP_NAME}

push:
	$(eval APP_NAME := $$APP_NAME)	
	make build APP_NAME="${APP_NAME}"
	docker tag ${APP_NAME} ${ECR_REPO}/${TAG_NAME} 
	docker push ${ECR_REPO}/${TAG_NAME}

deploy:
	make push
	chmod 755 deploy.sh
	./deploy.sh ${ENVIRONMENT} ${ECR_REPO} ${TAG_NAME}

deploy-staging: 
	make deploy ENVIRONMENT=staging

deploy-production:
	make deploy ENVIRONMENT=production
