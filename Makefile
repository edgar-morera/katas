default: up

COMPOSER_ROOT ?= /var/www/html
PROJECT_ROOT ?= /var/www/html
PHP_CONTAINER ?= katas_php

## help	:	Print commands help.
.PHONY: help
help :
	@sed -n 's/^##//p' Makefile


## up	:	Start up containers.
.PHONY: up
up:
	@echo "Starting up containers for katas..."
	docker-compose pull
	docker-compose up -d --remove-orphans

## down	:	Stop containers.
.PHONY: down
down: stop

## start	:	Start containers without updating.
.PHONY: start
start:
	@echo "Starting containers for katas from where you left off..."
	@docker-compose start

## stop	:	Stop containers.
.PHONY: stop
stop:
	@echo "Stopping containers for katas..."
	@docker-compose stop

## restart	:	Restart containers without updating.
.PHONY: restart
restart:
	docker-compose stop
	docker-compose up -d --remove-orphans
	
## prune	:	Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune mariadb	: Prune `mariadb` container and remove its volumes.
##		prune mariadb solr	: Prune `mariadb` and `solr` containers and remove their volumes.
.PHONY: prune
prune:
	@echo "Removing containers for katas..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps	:	List running containers.
.PHONY: ps
ps:
	@docker ps --filter name='katas*'

## shell	:	Access `php` container via shell.
##		You can optionally pass an argument with a service name to open a shell on the specified container
.PHONY: shell
shell:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='katas_$(or $(filter-out $@,$(MAKECMDGOALS)), 'php')' --format "{{ .ID }}") sh

## bash	:	Access `php` container via bash.
##		You can optionally pass an argument with a service name to open a bash on the specified container
.PHONY: bash
bash:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='katas_$(or $(filter-out $@,$(MAKECMDGOALS)), 'php')' --format "{{ .ID }}") /bin/bash

## composer	:	Executes `composer` command into the project folder.
##		To use "--flag" arguments include them in quotation marks.
##		For example: make composer "install --no-cache"
.PHONY: composer
composer:
	docker exec -it $(shell docker ps --filter name='^/$(PHP_CONTAINER)' --format "{{ .ID }}") composer --working-dir=$(COMPOSER_ROOT) $(filter-out $@,$(MAKECMDGOALS))

## exec	:	Executes command in a php container.
##		To use "--flag" arguments include them in quotation marks.
##		For example: make exec "php -i"
.PHONY: exec
exec:
	docker exec -it $(shell docker ps --filter name='^/$(PHP_CONTAINER)' --format "{{ .ID }}") --working-dir=$(PROJECT_ROOT) $(filter-out $@,$(MAKECMDGOALS))

## logs	:	View containers logs.
##		You can optinally pass an argument with the service name to limit logs
##		logs php	: View `php` container logs.
##		logs nginx php	: View `nginx` and `php` containers logs.
.PHONY: logs
logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

## tests	:	Executes unit tests for one kata.
##		For example: make tests Mastermind
.PHONY: tests
tests:
	docker exec -it $(shell docker ps --filter name='^/$(PHP_CONTAINER)' --format "{{ .ID }}") ./vendor/bin/phpunit $(filter-out $@,$(MAKECMDGOALS))/tests --testdox --colors	

# https://stackoverflow.com/a/6273809/1826109
%:
	@: