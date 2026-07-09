[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/yx8Hj6pC)

# BookSphere

BookSphere is a Spring Cloud microservices monorepo for the MSS301 distributed library management project.

## Services

| Service | Port | Database |
| --- | ---: | --- |
| api-gateway | 8080 | - |
| discovery-server | 8761 | - |
| config-server | 8888 | - |
| auth-service | 8081 | DBAuth |
| book-service | 8082 | DBBook |
| borrow-service | 8083 | DBBorrow |
| fine-service | 8084 | DBFine |
| notification-service | 8085 | DBNotification |

## Run

```bash
cp .env.example .env
```

Run the full local stack with Docker Compose:

```bash
docker compose up -d --build
```

Then use the system through the API Gateway at `http://localhost:8080`.

For normal restarts after the images have already been built, use the existing containers/images:

```bash
docker compose up -d
```

If the stack is only stopped and no code changed, `stop`/`start` is even faster:

```bash
docker compose stop
docker compose start
```

When changing code in one service, rebuild only that service instead of the whole stack:

```bash
docker compose up -d --build api-gateway
docker compose up -d --build borrow-service
```

You can still start only infrastructure containers and run Spring Boot services manually:

```bash
docker compose up -d mysql redis zipkin
```

MySQL init scripts create one database per business service. Business services use JPA/Hibernate code-first schema generation with `spring.jpa.hibernate.ddl-auto=update` and seed required sample data through `data.sql`.

Useful Docker Compose commands:

```bash
docker compose ps
docker compose logs -f api-gateway
docker compose down
```

## Build

Each service is an independent Maven project using Java 21 and Spring Boot 3.x.

```bash
cd discovery-server && mvn clean package -DskipTests
cd ../config-server && mvn clean package -DskipTests
cd ../api-gateway && mvn clean package -DskipTests
cd ../auth-service && mvn clean package -DskipTests
cd ../book-service && mvn clean package -DskipTests
cd ../borrow-service && mvn clean package -DskipTests
cd ../fine-service && mvn clean package -DskipTests
cd ../notification-service && mvn clean package -DskipTests
```
