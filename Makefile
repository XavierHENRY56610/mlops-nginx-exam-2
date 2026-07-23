start-project:
	docker compose -p nginxexam up -d --build

stop-project:
	docker compose -p nginxexam down

test:
	bash tests/run_tests.sh

links:
	@echo "Nginx Gateway: https://localhost"
	@echo "Prometheus: http://localhost:9090"
	@echo "Grafana: http://localhost:3000"
