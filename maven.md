
### 每次都会重新拉取snapshot
<profile>
     <id>alwaysActiveProfile</id>
     <activation>
      <!-- 是否默认激活 -->
      <activeByDefault>false</activeByDefault>
     </activation>
     <repositories>
        <repository>
          <id>alwaysActiveProfile</id>
          <name>alwaysActiveProfile Snapshots</name>
          <snapshots>
            <enabled>true</enabled>
            <!-- 重点在这里，每次都会重新拉取snapshot -->
            <updatePolicy>always</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
          </snapshots>
          <url>http://192.168.10.31:8081/repository/public</url>
          <layout>default</layout>
        </repository>
      </repositories>
    </profile>
  </profiles>
