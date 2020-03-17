## Certificate

Place AppCenter signing certificate in the project root. Available in 1Password. Put the key/store password in local.properties as "covid19_pwd":

```
covid19_pwd=...
```

## Upload new release to AppCenter

Use the provided `upload-to-appcenter` script from the project root folder.

```
$ ./upload-to-appcenter
```