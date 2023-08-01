
start:
	docker compose -f docker-compose.yaml up -d

stop:
	docker compose -f docker-compose.yaml down	

build:
	docker compose -f docker-compose.yaml up --build -d

test-rspec:
	docker compose run -e "RAILS_ENV=test" campaigns_discount bundle exec rspec

logs:
	docker logs -f campaigns_discount