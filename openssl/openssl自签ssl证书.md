## 创建根证书私钥ca.key
`openssl genrsa -out $yourDomain-ca.key 2048`

## 利用根证书私钥ca.key创建根证书ca.crt
**这里/C表示国家(Country)，只能是国家字母缩写，如CN、US等；/ST表示州或者省(State/Provice)；/L表示城市或者地区(Locality)；/O表示组织名(Organization Name)；/OU其他显示内容，一般会显示在颁发者这栏。**

`openssl req -new -x509 -sha256 -days 36500 -key $yourDomain-ca.key -out $yourDomain-ca.crt -subj \
"/C=CN/ST=ChongQing/L=ChongQing/O=$yourON/OU=yourCA"`

## 创建ssl证书私钥
`openssl genrsa -out $yourDomain-server.key 2048`

## 利用ssl私钥server.key创建SSL证书请求文件server.csr
**需要注意的是，/O字段内容必须与刚才的CA根证书相同；/CN字段为公用名称(Common Name)，必须为网站的域名(不带www)；/OU字段最好也与为网站域名，当然选择其他名字也没关系。**
`openssl req -new -key $yourDomain-server.key -sha256 -out $yourDomain-server.csr -subj \
"/C=CN/ST=ChongQing/L=ChongQing/O=$yourON/OU=$yourDomain/CN=$yourDomain"`

## 利用根证书签署SSL证书crt
```
mkdir demoCA
cd demoCA
mkdir newcerts
touch index.txt
echo '01' > serial
cd ..

openssl ca -in $yourDomain-server.csr -sha256 -days 36500 -out $yourDomain-server.crt -cert $yourDomain-ca.crt -keyfile $yourDomain-ca.key
```

## 配置
$yourDomain-server.crt
$yourDomain-server.key