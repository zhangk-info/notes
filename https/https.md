# 关于java和tomcat对于ssl的配置
server.ssl.key-store =>用于向其他呼叫您的客户端进行身份验证（服务器）
javax.net.ssl.trustStore =>用于对您从Spring Boot应用程序作为客户端调用的服务器进行身份验证。
server.ssl.trust-store =>仅在与Spring一起使用2-way ssl时使用，在该方法中，您将自己身份验证为使用其他SSL安全服务器的客户端。实施SSL（单向ssl）时，您可能不会经常使用此方法。所以坚持前两个就可以了。