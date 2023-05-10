# 关于java和tomcat对于ssl的配置
server.ssl.key-store =>用于向其他呼叫您的客户端进行身份验证（服务器）
javax.net.ssl.trustStore =>用于对您从Spring Boot应用程序作为客户端调用的服务器进行身份验证。
server.ssl.trust-store =>仅在与Spring一起使用2-way ssl时使用，在该方法中，您将自己身份验证为使用其他SSL安全服务器的客户端。实施SSL（单向ssl）时，您可能不会经常使用此方法。所以坚持前两个就可以了。

# 或者去掉ssl

## httpRequest
```
        HttpRequest httpRequest = HttpUtil.createRequest(Method.GET, "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + wxOpenAppId + "&secret=" + wxOpenSecret + "&code=" + wxOpenCode + "&grant_type=authorization_code");
                // 跳过ssl认证
                httpRequest.setSSLSocketFactory(SSLContextBuilder.create().setTrustManagers(new X509TrustManager() {
                    @Override
                    public X509Certificate[] getAcceptedIssuers() {
                        return null;
                    }

                    @Override
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        // don't check
                    }

                    @Override
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        // don't check
                    }
                }).buildChecked().getSocketFactory());
                String jsonStr = httpRequest.timeout(HttpGlobalConfig.getTimeout()).execute().body();

```

## 微信sdk
```
     // 设置ApacheHttpClientBuilder
        ApacheHttpClientBuilder apacheHttpClientBuilder = DefaultApacheHttpClientBuilder.get();
        apacheHttpClientBuilder.sslConnectionSocketFactory(new SSLConnectionSocketFactory(SSLContextBuilder.create().setTrustManagers(new X509TrustManager() {
            @Override
            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }

            @Override
            public void checkClientTrusted(X509Certificate[] certs, String authType) {
                // don't check
            }

            @Override
            public void checkServerTrusted(X509Certificate[] certs, String authType) {
                // don't check
            }
        }).build()));
        if (wxMaConfig instanceof WxMaDefaultConfigImpl) {
            ((WxMaDefaultConfigImpl) wxMaConfig).setApacheHttpClientBuilder(apacheHttpClientBuilder);
        }
```