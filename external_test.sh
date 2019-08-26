kubectl delete -f external_test_k8s.yaml
docker build -t external-test .
kubectl apply -f external_test_k8s.yaml
#kail -l run=external-test &
#sleep 2c
#kubectl delete pod -l run=external-test