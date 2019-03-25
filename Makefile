build-all: build-ui build-comment build-post build-prometheus build-blackbox-exporter build-mongodb-exporter

build-ui:
	docker build -t $(USER_NAME)/ui src/ui/

build-comment:
	docker build -t $(USER_NAME)/comment src/comment/

build-post:
	docker build -t $(USER_NAME)/post src/post-py/

build-prometheus:
	docker build -t $(USER_NAME)/prometheus monitoring/prometheus/

build-blackbox-exporter:
	docker build -t $(USER_NAME)/blackbox-exporter:0.14.0 monitoring/blackbox-exporter/

build-mongodb-exporter:
	docker build -t $(USER_NAME)/mongodb-exporter:0.7.0 monitoring/mongodb-exporter/

push-all: push-ui push-comment push-post push-prometheus push-blackbox-exporter push-mongodb-exporter

push-ui:
	docker push $(USER_NAME)/ui
push-comment:
	docker push $(USER_NAME)/comment
push-post:
	docker push $(USER_NAME)/post
push-prometheus:
	docker push $(USER_NAME)/prometheus
push-blackbox-exporter:
	docker push $(USER_NAME)/blackbox-exporter:0.14.0
push-mongodb-exporter:
	docker push $(USER_NAME)/mongodb-exporter:0.7.0






