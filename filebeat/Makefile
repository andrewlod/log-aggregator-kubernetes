default: test

RELEASE := filebeat
TIMEOUT := 1200s
NAMESPACE := monitoring

install:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml -n $(NAMESPACE) $(RELEASE) elastic/filebeat

test: install goss

purge:
	helm del $(RELEASE) -n $(NAMESPACE)