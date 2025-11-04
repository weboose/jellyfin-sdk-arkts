import { AxiosInstance, AxiosPromise, RawAxiosRequestConfig } from "@ohos/axios";
import { Api,
    BaseItemDto,
    Configuration,
    UserLibraryApiAxiosParamCreator,
    UserLibraryApiGetItemRequest } from "@weboose/jellyfin-sdk-arkts";
import { BaseAPI,
    BASE_PATH,
    operationServerMap,
    RequestArgs } from "@weboose/jellyfin-sdk-arkts/src/main/ets/generated-client/base";
import { createRequestFunction,
    DUMMY_BASE_URL,
    toPathString} from "@weboose/jellyfin-sdk-arkts/src/main/ets/generated-client/common";
import globalAxios from '@ohos/axios';
import { url } from "@kit.ArkTS";

class UserItemApi extends BaseAPI
{
    public getItem(requestParameters: UserLibraryApiGetItemRequest, options?: RawAxiosRequestConfig) {
        return UserItemApiFp(this.configuration).getItem(requestParameters.itemId, requestParameters.userId, options).then((request) => request(this.axios, this.basePath));
    }
}

export function UserItemApiFp(configuration?: Configuration){
    const localVarAxiosParamCreator = UserLibraryApiAxiosParamCreator(configuration);
    return {
        async getItem(itemId: string, userId?: string, options?: RawAxiosRequestConfig): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<BaseItemDto>> {
            const localVarAxiosArgs = await localVarAxiosParamCreator.getItem(itemId, userId, options);
            localVarAxiosArgs.url = toPathString(new url.URL(`/Users/${userId}/Items/${itemId}`, DUMMY_BASE_URL));

            const localVarOperationServerIndex = configuration?.serverIndex ?? 0;
            const localVarOperationServerBasePath = operationServerMap['UserLibraryApi.getItem']?.[localVarOperationServerIndex]?.url;
            return (axios, basePath) => createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)(axios, localVarOperationServerBasePath || basePath);
        },
    }
}


export function getItemApi(api:Api)
{
    return new UserItemApi(api.configuration, undefined, api.axiosInstance);
}