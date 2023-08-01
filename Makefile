
start:
	docker compose -f docker-compose.yaml up -d

stop:
	docker compose -f docker-compose.yaml down	

build:
	docker compose -f docker-compose.yaml up --build -d

logs:
	docker logs -f campaigns_discount