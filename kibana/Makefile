default: test

RELEASE := kibana
TIMEOUT := 1200s

install:
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) elastic/kibana

test: install goss

purge:
	microk8s helm del $(RELEASE)