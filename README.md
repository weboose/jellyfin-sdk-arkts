<h1 align="center">jellyfin-sdk-arkts</h1>
<h3 align="center">Jellyfin官网 <a href="https://jellyfin.org">Jellyfin Project</a></h3>

---


基于官方typescript适配（当前版本：v0.13.0）

> 警告：只做了简单测试，如有问题请提交报告

## 安装

```sh
ohpm install @weboose/jellyfin-sdk-arkts
```

### 支持的 Jellyfin服务端版本

| SDK Version | Jellyfin Version |
|:-:|:-:|
| 0.13.0 | 10.11.x |
| 0.12.0 | 10.11.x |
| 0.11.0 | 10.10.x |
| 0.10.0 | 10.9.x |
| 0.9.0 | 10.9.x |
| 0.8.2 - 0.6.0 | 10.8.1 - 10.8.13 |
| 0.5.0 | 10.8.0 |
| <0.5.0 | 10.7.x |

> 注意: 其他版本未经测试


## 使用
> 与jellyfin官方文档一致

```js
// Create a new instance of the SDK
const jellyfin = new Jellyfin({
    clientInfo: {
        name: 'My Client Application',
        version: '1.0.0'
    },
    deviceInfo: {
        name: 'Device Name',
        id: 'unique-device-id'
    }
});

// Find a valid server by trying to connect using common protocols and ports.
// Each server receives a score based on security, speed, and other criteria.
const servers = await jellyfin.discovery.getRecommendedServerCandidates('demo.jellyfin.org/stable');
// A utility function for finding the best result is available.
// If there is no "best" server, an error message should be displayed.
const best = jellyfin.discovery.findBestServer(servers);

// Create an API instance
const api = jellyfin.createApi(best.address);

// Each API endpoint is represented by a class in the generated client.
// Helper utility functions are provided under `/lib/utils/api/` to create an
// instance of a specific Jellyfin API using the shared Configuration and Axios
// instance from the `api` object created above.

// For example, the SystemApi can be generated using the `getSystemApi`
// function in `/lib/utils/api/system-api`.

// Fetch the public system info
const info = await getSystemApi(api).getPublicSystemInfo();
console.log('Info =>', info.data);

// Fetch the list of public users
const users = await getUserApi(api).getPublicUsers();
console.log('Users =>', users.data);

// Login with a username and password.
const auth = await getUserApi(this).authenticateUserByName({ authenticateUserByName: { Username: 'demo', Pw: '' } });
console.log('Auth =>', auth.data);

// Authentication state is stored internally in the Api class, so now
// requests that require authentication can be made normally
const libraries = await getLibraryApi(api).getMediaFolders();
console.log('Libraries =>', libraries.data);

// Logout the current user.
await getSessionApi(api).reportSessionEnded();
```