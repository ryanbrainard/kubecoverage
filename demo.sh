kubectl delete namespace go-test-coverage-demo
docker build -t go-test-coverage-demo/test-exec .
kubectl apply -f demo.yaml
#kail -l run=external-test &
#sleep 2c
#kubectl delete pod -l run=external-test
