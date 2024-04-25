default: test

RELEASE := helm-kibana-default
TIMEOUT := 1200s

install:
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install $(RELEASE) elastic/kibana

test: install goss

purge:
	microk8s helm del $(RELEASE)