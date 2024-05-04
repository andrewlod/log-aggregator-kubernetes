default: test

RELEASE := kibana
TIMEOUT := 1200s
NAMESPACE := monitoring

install-dev:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values-dev.yaml -n $(NAMESPACE) $(RELEASE) elastic/kibana

install-prod:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values-prod.yaml -n $(NAMESPACE) $(RELEASE) elastic/kibana
	
purge:
	kubectl delete configmap kibana-kibana-helm-scripts -n $(NAMESPACE) || true
	kubectl delete serviceaccount pre-install-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete serviceaccount post-delete-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete roles post-delete-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete roles pre-install-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete rolebindings post-delete-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete rolebindings pre-install-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete job post-delete-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete job pre-install-kibana-kibana -n $(NAMESPACE) || true
	kubectl delete secret kibana-kibana-es-token -n $(NAMESPACE) || true
	helm del $(RELEASE) -n $(NAMESPACE)
	
test: install goss