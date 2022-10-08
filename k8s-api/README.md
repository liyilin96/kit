### k8s api

***
when k8s resources in status 'Terminating', try delete them by api
***

1. open proxy in another terminal
```sh
kubectl proxy
```
- default ip `127.0.0.1:8001`
2. run shell
```sh
chmod +x delete_ns.sh && ./delete_ns.sh
```
***
- note: to delete json block like this
```json
  "spec": {
    "finalizer": [
      "kubernates"
    ]
  }
```
 `sed` is used to edit json, recheck here before use is
