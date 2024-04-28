default: test

RELEASE := kibana
TIMEOUT := 1200s

install-dev:
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) elastic/kibana

purge-dev:
	microk8s kubectl delete configmap kibana-kibana-helm-scripts || true
	microk8s kubectl delete serviceaccount pre-install-kibana-kibana || true
	microk8s kubectl delete serviceaccount post-delete-kibana-kibana || true
	microk8s kubectl delete roles pre-install-kibana-kibana || true
	microk8s kubectl delete rolebindings pre-install-kibana-kibana || true
	microk8s kubectl delete job pre-install-kibana-kibana || true
	microk8s helm del $(RELEASE)
	
test: install goss