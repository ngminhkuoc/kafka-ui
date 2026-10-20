# Run Kafka UI locally from the prebuilt Docker image (no compile needed).
# Stack definition: local/docker-compose.yml

COMPOSE := docker compose -f local/docker-compose.yml
URL     := http://localhost:8080

ifeq ($(OS),Windows_NT)
  PS := powershell -NoProfile -ExecutionPolicy Bypass -File local/kafka-ui.ps1
endif

.PHONY: help start stop restart status logs update open

help:
	@echo Targets:
	@echo   make start    - start Docker if needed, run Kafka + Kafka UI, open the browser
	@echo   make stop     - stop and remove the containers (Kafka data is kept)
	@echo   make restart  - stop then start
	@echo   make status   - show container status
	@echo   make logs     - follow Kafka UI logs
	@echo   make update   - pull the latest images and recreate
	@echo   make open     - open $(URL) in the browser

ifeq ($(OS),Windows_NT)
start:
	$(PS) start
open:
	powershell -NoProfile -Command "Start-Process $(URL)"
else
start:
	$(COMPOSE) up -d
	@echo Waiting for Kafka UI...
	@for i in $$(seq 60); do curl -sf $(URL)/actuator/health >/dev/null && break; sleep 2; done
	@$(MAKE) --no-print-directory open
open:
	@(command -v xdg-open >/dev/null && xdg-open $(URL)) || open $(URL)
endif

stop:
	$(COMPOSE) down

restart: stop start

status:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f kafka-ui

update:
	$(COMPOSE) pull
	$(COMPOSE) up -d
