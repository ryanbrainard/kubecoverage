docker build -t external-test .
kubectl delete -f external_test_k8s.yaml
kubectl replace -f external_test_k8s.yaml
kail -l run=external-test &
sleep 2
kubectl delete pod -l run=external-test
kail -l run=external-test
