import { RawAxiosRequestConfig } from "@ohos/axios";
import { Api, Configuration, UserLibraryApiGetItemRequest } from "@weboose/jellyfin-sdk-arkts";
import { BaseAPI, BASE_PATH, operationServerMap,
    RequestArgs } from "@weboose/jellyfin-sdk-arkts/src/main/ets/generated-client/base";
import {
    assertParamExists,
    createRequestFunction,
    DUMMY_BASE_URL,
    setApiKeyToObject,
    setSearchParams,
    toPathString} from "@weboose/jellyfin-sdk-arkts/src/main/ets/generated-client/common";
import globalAxios from '@ohos/axios';
import { url } from "@kit.ArkTS";

export function getUserItemsApi(api: Api)
{
    return new UserItemsApi(api.configuration, undefined, api.axiosInstance);
}


export class UserItemsApi extends BaseAPI
{

    async getItem(requestParameters: UserLibraryApiGetItemRequest, options?: RawAxiosRequestConfig)
    {
        return UserItemsApiFp(this.configuration).getItem(requestParameters.itemId, requestParameters.userId);
    }

}

export const UserItemsApiAxiosParamCreator = (configuration?: Configuration) => {
    return {
        getItem: async (itemId: string, userId?: string, options: RawAxiosRequestConfig = {}): Promise<RequestArgs> => {
            // verify required parameter 'itemId' is not null or undefined
            assertParamExists('getItem', 'itemId', itemId)
            const localVarPath = `/Users/{userId}/Items/{itemId}`
                .replace(`{${"itemId"}}`, encodeURIComponent(String(itemId)))
                .replace(`{${"userId"}}`, encodeURIComponent(String(userId)));

            // use dummy base URL string because the URL constructor only accepts absolute URLs.
            const localVarUrlObj = new url.URL(localVarPath, DUMMY_BASE_URL);
            let baseOptions;
            if (configuration) {
                baseOptions = configuration.baseOptions;
            }

            const localVarRequestOptions = { method: 'GET', ...baseOptions, ...options};
            const localVarHeaderParameter = {} as any;
            const localVarQueryParameter = {} as any;

            // authentication CustomAuthentication required
            await setApiKeyToObject(localVarHeaderParameter, "Authorization", configuration)

            if (userId !== undefined) {
                localVarQueryParameter['userId'] = userId;
            }



            setSearchParams(localVarUrlObj, localVarQueryParameter);
            let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {};
            localVarRequestOptions.headers = {...localVarHeaderParameter, ...headersFromBaseOptions, ...options.headers};

            return {
                url: toPathString(localVarUrlObj),
                options: localVarRequestOptions,
            };
        }
    }
}

export const UserItemsApiFp = (configuration?: Configuration) => {
    const localVarAxiosParamCreator = UserItemsApiAxiosParamCreator(configuration)
    return {
        getItem: async (itemId: string, userId?: string, options?: RawAxiosRequestConfig) => {
            const localVarAxiosArgs = await localVarAxiosParamCreator.getItem(itemId, userId, options);
            const localVarOperationServerIndex = configuration?.serverIndex ?? 0;
            const localVarOperationServerBasePath = operationServerMap['UserItemsApi.getItem']?.[localVarOperationServerIndex]?.url;
            // fetch data
            return (axios, basePath) => createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)(axios, localVarOperationServerBasePath || basePath);
        }
    }
}