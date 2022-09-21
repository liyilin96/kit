### k8s conformance in air-gap env

***
+ check conformance in k8s https://github.com/cncf/k8s-conformance/blob/master/instructions.md
+ use sonobuoy https://github.com/vmware-tanzu/sonobuoy/issues/1223

***
1. set up check-script
```sh
nohup ./check_status.sh > mycheckimg.log 2>&1 &
```
- then you can get pid [CHECK_PID]
2. edit sonobuoy config 
```
sonobuoy gen default-image-config > custom-repo-config.yaml
```
3. start up sonobuoy
```sh
sonobuoy run  --mode=certified-conformance  \
    --plugin e2e --e2e-repo-config ./custom-repo-config.yaml 
    --kube-conformance-image docker.io/ycsit/conformance:v1.24.0 
    --sonobuoy-image docker.io/sonobuoy/sonobuoy:v0.56.10 
```
4. check sonobuoy and wait for success
```sh
sonobuoy status
```
```sh
sonobuoy logs
```
5. get the result
```sh
outfile=$(sonobuoy retrieve)
```
```sh
mkdir ./results; tar xzf $outfile -C ./results
```
6. clean up 
```sh
sonobuoy delete
```
```sh
kill [CHECK_PID]
```
- or you can search pid first
```sh
ps -aux | grep "check"
```
