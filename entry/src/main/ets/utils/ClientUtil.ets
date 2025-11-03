import axios, { InternalAxiosRequestConfig } from "@ohos/axios";
import { DeviceUtil, LogUtil } from "@pura/harmony-utils";
import { isVersionLess, Jellyfin } from "@weboose/jellyfin-sdk-arkts";
import { uri, url } from "@kit.ArkTS";

interface CreateApiOptions
{
    server: string;
    deviceId: string;
    deviceName?: string;
    accessToken?: string;
    serverVersion?: string;
}

export class ClientUtil
{
    static createApi(options: CreateApiOptions){
        LogUtil.info(`createApi: ${JSON.stringify(options)}`);
        return new Jellyfin({
            clientInfo: {
                name: 'jellyfin sdk demo',
                version: '1.0.0'
            },
            deviceInfo: {
                id: options.deviceId,
                name: options.deviceName || DeviceUtil.getMarketName()
            }
        }).createApi(options.server, options.accessToken, ClientUtil.createAxiosInstance(options));
    }

    static createAxiosInstance(options: CreateApiOptions){
        const axiosInstance = axios.create({
            baseURL: options.server
        });
        axiosInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
            LogUtil.info(`fetch: ${config.url}`);
            if(config.url){
                try {
                    const apiUrl = new uri.URI(config.url);
                    // 如果低于10.9.0的版本需要做一些兼容性改动
                    if (isVersionLess(options.serverVersion, '10.9.0')) {
                        if(apiUrl.path === '/UserViews'){
                            config.url = `/Users/${apiUrl.getQueryValue('userId')}/Views`;
                            LogUtil.info('patch: ', config.url);
                        }
                    }
                } catch (error) {
                    // TODO: Implement error handling.
                    LogUtil.error(error);
                }
            }
            return config;
        });

        return axiosInstance;
    }
}