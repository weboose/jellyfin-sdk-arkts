import { AxiosInstance, AxiosPromise, RawAxiosRequestConfig } from "@ohos/axios";
import { Api,
    BaseItemDto,
    BaseItemDtoQueryResult,
    BaseItemKind,
    Configuration,
    ImageType,
    ItemFields,
    ItemFilter,
    ItemsApiGetItemsRequest,
    ItemSortBy,
    LocationType,
    MediaType,
    SeriesStatus,
    SortOrder,
    UserLibraryApiGetItemRequest,
    VideoType} from "@weboose/jellyfin-sdk-arkts";
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
    public getItem(requestParameters: UserLibraryApiGetItemRequest, options?: RawAxiosRequestConfig) {
        return UserItemsApiFp(this.configuration).getItem(requestParameters.itemId, requestParameters.userId, options).then((request) => request(this.axios, this.basePath));
    }

    public getItems(requestParameters: ItemsApiGetItemsRequest = {}, options?: RawAxiosRequestConfig) {
        return UserItemsApiFp(this.configuration).getItems(requestParameters.userId, requestParameters.maxOfficialRating, requestParameters.hasThemeSong, requestParameters.hasThemeVideo, requestParameters.hasSubtitles, requestParameters.hasSpecialFeature, requestParameters.hasTrailer, requestParameters.adjacentTo, requestParameters.indexNumber, requestParameters.parentIndexNumber, requestParameters.hasParentalRating, requestParameters.isHd, requestParameters.is4K, requestParameters.locationTypes, requestParameters.excludeLocationTypes, requestParameters.isMissing, requestParameters.isUnaired, requestParameters.minCommunityRating, requestParameters.minCriticRating, requestParameters.minPremiereDate, requestParameters.minDateLastSaved, requestParameters.minDateLastSavedForUser, requestParameters.maxPremiereDate, requestParameters.hasOverview, requestParameters.hasImdbId, requestParameters.hasTmdbId, requestParameters.hasTvdbId, requestParameters.isMovie, requestParameters.isSeries, requestParameters.isNews, requestParameters.isKids, requestParameters.isSports, requestParameters.excludeItemIds, requestParameters.startIndex, requestParameters.limit, requestParameters.recursive, requestParameters.searchTerm, requestParameters.sortOrder, requestParameters.parentId, requestParameters.fields, requestParameters.excludeItemTypes, requestParameters.includeItemTypes, requestParameters.filters, requestParameters.isFavorite, requestParameters.mediaTypes, requestParameters.imageTypes, requestParameters.sortBy, requestParameters.isPlayed, requestParameters.genres, requestParameters.officialRatings, requestParameters.tags, requestParameters.years, requestParameters.enableUserData, requestParameters.imageTypeLimit, requestParameters.enableImageTypes, requestParameters.person, requestParameters.personIds, requestParameters.personTypes, requestParameters.studios, requestParameters.artists, requestParameters.excludeArtistIds, requestParameters.artistIds, requestParameters.albumArtistIds, requestParameters.contributingArtistIds, requestParameters.albums, requestParameters.albumIds, requestParameters.ids, requestParameters.videoTypes, requestParameters.minOfficialRating, requestParameters.isLocked, requestParameters.isPlaceHolder, requestParameters.hasOfficialRating, requestParameters.collapseBoxSetItems, requestParameters.minWidth, requestParameters.minHeight, requestParameters.maxWidth, requestParameters.maxHeight, requestParameters.is3D, requestParameters.seriesStatus, requestParameters.nameStartsWithOrGreater, requestParameters.nameStartsWith, requestParameters.nameLessThan, requestParameters.studioIds, requestParameters.genreIds, requestParameters.enableTotalRecordCount, requestParameters.enableImages, options).then((request) => request(this.axios, this.basePath));
    }

}

export const UserItemsApiAxiosParamCreator = (configuration?: Configuration) => {
    return {
        getItems: async (userId?: string, maxOfficialRating?: string, hasThemeSong?: boolean, hasThemeVideo?: boolean, hasSubtitles?: boolean, hasSpecialFeature?: boolean, hasTrailer?: boolean, adjacentTo?: string, indexNumber?: number, parentIndexNumber?: number, hasParentalRating?: boolean, isHd?: boolean, is4K?: boolean, locationTypes?: Array<LocationType>, excludeLocationTypes?: Array<LocationType>, isMissing?: boolean, isUnaired?: boolean, minCommunityRating?: number, minCriticRating?: number, minPremiereDate?: string, minDateLastSaved?: string, minDateLastSavedForUser?: string, maxPremiereDate?: string, hasOverview?: boolean, hasImdbId?: boolean, hasTmdbId?: boolean, hasTvdbId?: boolean, isMovie?: boolean, isSeries?: boolean, isNews?: boolean, isKids?: boolean, isSports?: boolean, excludeItemIds?: Array<string>, startIndex?: number, limit?: number, recursive?: boolean, searchTerm?: string, sortOrder?: Array<SortOrder>, parentId?: string, fields?: Array<ItemFields>, excludeItemTypes?: Array<BaseItemKind>, includeItemTypes?: Array<BaseItemKind>, filters?: Array<ItemFilter>, isFavorite?: boolean, mediaTypes?: Array<MediaType>, imageTypes?: Array<ImageType>, sortBy?: Array<ItemSortBy>, isPlayed?: boolean, genres?: Array<string>, officialRatings?: Array<string>, tags?: Array<string>, years?: Array<number>, enableUserData?: boolean, imageTypeLimit?: number, enableImageTypes?: Array<ImageType>, person?: string, personIds?: Array<string>, personTypes?: Array<string>, studios?: Array<string>, artists?: Array<string>, excludeArtistIds?: Array<string>, artistIds?: Array<string>, albumArtistIds?: Array<string>, contributingArtistIds?: Array<string>, albums?: Array<string>, albumIds?: Array<string>, ids?: Array<string>, videoTypes?: Array<VideoType>, minOfficialRating?: string, isLocked?: boolean, isPlaceHolder?: boolean, hasOfficialRating?: boolean, collapseBoxSetItems?: boolean, minWidth?: number, minHeight?: number, maxWidth?: number, maxHeight?: number, is3D?: boolean, seriesStatus?: Array<SeriesStatus>, nameStartsWithOrGreater?: string, nameStartsWith?: string, nameLessThan?: string, studioIds?: Array<string>, genreIds?: Array<string>, enableTotalRecordCount?: boolean, enableImages?: boolean, options: RawAxiosRequestConfig = {}): Promise<RequestArgs> => {
            const localVarPath = `/Users/{userId}/Items`
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

            if (maxOfficialRating !== undefined) {
                localVarQueryParameter['maxOfficialRating'] = maxOfficialRating;
            }

            if (hasThemeSong !== undefined) {
                localVarQueryParameter['hasThemeSong'] = hasThemeSong;
            }

            if (hasThemeVideo !== undefined) {
                localVarQueryParameter['hasThemeVideo'] = hasThemeVideo;
            }

            if (hasSubtitles !== undefined) {
                localVarQueryParameter['hasSubtitles'] = hasSubtitles;
            }

            if (hasSpecialFeature !== undefined) {
                localVarQueryParameter['hasSpecialFeature'] = hasSpecialFeature;
            }

            if (hasTrailer !== undefined) {
                localVarQueryParameter['hasTrailer'] = hasTrailer;
            }

            if (adjacentTo !== undefined) {
                localVarQueryParameter['adjacentTo'] = adjacentTo;
            }

            if (indexNumber !== undefined) {
                localVarQueryParameter['indexNumber'] = indexNumber;
            }

            if (parentIndexNumber !== undefined) {
                localVarQueryParameter['parentIndexNumber'] = parentIndexNumber;
            }

            if (hasParentalRating !== undefined) {
                localVarQueryParameter['hasParentalRating'] = hasParentalRating;
            }

            if (isHd !== undefined) {
                localVarQueryParameter['isHd'] = isHd;
            }

            if (is4K !== undefined) {
                localVarQueryParameter['is4K'] = is4K;
            }

            if (locationTypes) {
                localVarQueryParameter['locationTypes'] = locationTypes;
            }

            if (excludeLocationTypes) {
                localVarQueryParameter['excludeLocationTypes'] = excludeLocationTypes;
            }

            if (isMissing !== undefined) {
                localVarQueryParameter['isMissing'] = isMissing;
            }

            if (isUnaired !== undefined) {
                localVarQueryParameter['isUnaired'] = isUnaired;
            }

            if (minCommunityRating !== undefined) {
                localVarQueryParameter['minCommunityRating'] = minCommunityRating;
            }

            if (minCriticRating !== undefined) {
                localVarQueryParameter['minCriticRating'] = minCriticRating;
            }

            if (minPremiereDate !== undefined) {
                localVarQueryParameter['minPremiereDate'] = (minPremiereDate as any instanceof Date) ?
                    (minPremiereDate as any).toISOString() :
                    minPremiereDate;
            }

            if (minDateLastSaved !== undefined) {
                localVarQueryParameter['minDateLastSaved'] = (minDateLastSaved as any instanceof Date) ?
                    (minDateLastSaved as any).toISOString() :
                    minDateLastSaved;
            }

            if (minDateLastSavedForUser !== undefined) {
                localVarQueryParameter['minDateLastSavedForUser'] = (minDateLastSavedForUser as any instanceof Date) ?
                    (minDateLastSavedForUser as any).toISOString() :
                    minDateLastSavedForUser;
            }

            if (maxPremiereDate !== undefined) {
                localVarQueryParameter['maxPremiereDate'] = (maxPremiereDate as any instanceof Date) ?
                    (maxPremiereDate as any).toISOString() :
                    maxPremiereDate;
            }

            if (hasOverview !== undefined) {
                localVarQueryParameter['hasOverview'] = hasOverview;
            }

            if (hasImdbId !== undefined) {
                localVarQueryParameter['hasImdbId'] = hasImdbId;
            }

            if (hasTmdbId !== undefined) {
                localVarQueryParameter['hasTmdbId'] = hasTmdbId;
            }

            if (hasTvdbId !== undefined) {
                localVarQueryParameter['hasTvdbId'] = hasTvdbId;
            }

            if (isMovie !== undefined) {
                localVarQueryParameter['isMovie'] = isMovie;
            }

            if (isSeries !== undefined) {
                localVarQueryParameter['isSeries'] = isSeries;
            }

            if (isNews !== undefined) {
                localVarQueryParameter['isNews'] = isNews;
            }

            if (isKids !== undefined) {
                localVarQueryParameter['isKids'] = isKids;
            }

            if (isSports !== undefined) {
                localVarQueryParameter['isSports'] = isSports;
            }

            if (excludeItemIds) {
                localVarQueryParameter['excludeItemIds'] = excludeItemIds;
            }

            if (startIndex !== undefined) {
                localVarQueryParameter['startIndex'] = startIndex;
            }

            if (limit !== undefined) {
                localVarQueryParameter['limit'] = limit;
            }

            if (recursive !== undefined) {
                localVarQueryParameter['recursive'] = recursive;
            }

            if (searchTerm !== undefined) {
                localVarQueryParameter['searchTerm'] = searchTerm;
            }

            if (sortOrder) {
                localVarQueryParameter['sortOrder'] = sortOrder;
            }

            if (parentId !== undefined) {
                localVarQueryParameter['parentId'] = parentId;
            }

            if (fields) {
                localVarQueryParameter['fields'] = fields;
            }

            if (excludeItemTypes) {
                localVarQueryParameter['excludeItemTypes'] = excludeItemTypes;
            }

            if (includeItemTypes) {
                localVarQueryParameter['includeItemTypes'] = includeItemTypes;
            }

            if (filters) {
                localVarQueryParameter['filters'] = filters;
            }

            if (isFavorite !== undefined) {
                localVarQueryParameter['isFavorite'] = isFavorite;
            }

            if (mediaTypes) {
                localVarQueryParameter['mediaTypes'] = mediaTypes;
            }

            if (imageTypes) {
                localVarQueryParameter['imageTypes'] = imageTypes;
            }

            if (sortBy) {
                localVarQueryParameter['sortBy'] = sortBy;
            }

            if (isPlayed !== undefined) {
                localVarQueryParameter['isPlayed'] = isPlayed;
            }

            if (genres) {
                localVarQueryParameter['genres'] = genres;
            }

            if (officialRatings) {
                localVarQueryParameter['officialRatings'] = officialRatings;
            }

            if (tags) {
                localVarQueryParameter['tags'] = tags;
            }

            if (years) {
                localVarQueryParameter['years'] = years;
            }

            if (enableUserData !== undefined) {
                localVarQueryParameter['enableUserData'] = enableUserData;
            }

            if (imageTypeLimit !== undefined) {
                localVarQueryParameter['imageTypeLimit'] = imageTypeLimit;
            }

            if (enableImageTypes) {
                localVarQueryParameter['enableImageTypes'] = enableImageTypes;
            }

            if (person !== undefined) {
                localVarQueryParameter['person'] = person;
            }

            if (personIds) {
                localVarQueryParameter['personIds'] = personIds;
            }

            if (personTypes) {
                localVarQueryParameter['personTypes'] = personTypes;
            }

            if (studios) {
                localVarQueryParameter['studios'] = studios;
            }

            if (artists) {
                localVarQueryParameter['artists'] = artists;
            }

            if (excludeArtistIds) {
                localVarQueryParameter['excludeArtistIds'] = excludeArtistIds;
            }

            if (artistIds) {
                localVarQueryParameter['artistIds'] = artistIds;
            }

            if (albumArtistIds) {
                localVarQueryParameter['albumArtistIds'] = albumArtistIds;
            }

            if (contributingArtistIds) {
                localVarQueryParameter['contributingArtistIds'] = contributingArtistIds;
            }

            if (albums) {
                localVarQueryParameter['albums'] = albums;
            }

            if (albumIds) {
                localVarQueryParameter['albumIds'] = albumIds;
            }

            if (ids) {
                localVarQueryParameter['ids'] = ids;
            }

            if (videoTypes) {
                localVarQueryParameter['videoTypes'] = videoTypes;
            }

            if (minOfficialRating !== undefined) {
                localVarQueryParameter['minOfficialRating'] = minOfficialRating;
            }

            if (isLocked !== undefined) {
                localVarQueryParameter['isLocked'] = isLocked;
            }

            if (isPlaceHolder !== undefined) {
                localVarQueryParameter['isPlaceHolder'] = isPlaceHolder;
            }

            if (hasOfficialRating !== undefined) {
                localVarQueryParameter['hasOfficialRating'] = hasOfficialRating;
            }

            if (collapseBoxSetItems !== undefined) {
                localVarQueryParameter['collapseBoxSetItems'] = collapseBoxSetItems;
            }

            if (minWidth !== undefined) {
                localVarQueryParameter['minWidth'] = minWidth;
            }

            if (minHeight !== undefined) {
                localVarQueryParameter['minHeight'] = minHeight;
            }

            if (maxWidth !== undefined) {
                localVarQueryParameter['maxWidth'] = maxWidth;
            }

            if (maxHeight !== undefined) {
                localVarQueryParameter['maxHeight'] = maxHeight;
            }

            if (is3D !== undefined) {
                localVarQueryParameter['is3D'] = is3D;
            }

            if (seriesStatus) {
                localVarQueryParameter['seriesStatus'] = seriesStatus;
            }

            if (nameStartsWithOrGreater !== undefined) {
                localVarQueryParameter['nameStartsWithOrGreater'] = nameStartsWithOrGreater;
            }

            if (nameStartsWith !== undefined) {
                localVarQueryParameter['nameStartsWith'] = nameStartsWith;
            }

            if (nameLessThan !== undefined) {
                localVarQueryParameter['nameLessThan'] = nameLessThan;
            }

            if (studioIds) {
                localVarQueryParameter['studioIds'] = studioIds;
            }

            if (genreIds) {
                localVarQueryParameter['genreIds'] = genreIds;
            }

            if (enableTotalRecordCount !== undefined) {
                localVarQueryParameter['enableTotalRecordCount'] = enableTotalRecordCount;
            }

            if (enableImages !== undefined) {
                localVarQueryParameter['enableImages'] = enableImages;
            }



            setSearchParams(localVarUrlObj, localVarQueryParameter);
            let headersFromBaseOptions = baseOptions && baseOptions.headers ? baseOptions.headers : {};
            localVarRequestOptions.headers = {...localVarHeaderParameter, ...headersFromBaseOptions, ...options.headers};

            return {
                url: toPathString(localVarUrlObj),
                options: localVarRequestOptions,
            };
        },
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
        async getItem(itemId: string, userId?: string, options?: RawAxiosRequestConfig): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<BaseItemDto>> {
            const localVarAxiosArgs = await localVarAxiosParamCreator.getItem(itemId, userId, options);
            const localVarOperationServerIndex = configuration?.serverIndex ?? 0;
            const localVarOperationServerBasePath = operationServerMap['UserItemsApi.getItem']?.[localVarOperationServerIndex]?.url;
            return (axios, basePath) => createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)(axios, localVarOperationServerBasePath || basePath);
        },
        async getItems(userId?: string, maxOfficialRating?: string, hasThemeSong?: boolean, hasThemeVideo?: boolean, hasSubtitles?: boolean, hasSpecialFeature?: boolean, hasTrailer?: boolean, adjacentTo?: string, indexNumber?: number, parentIndexNumber?: number, hasParentalRating?: boolean, isHd?: boolean, is4K?: boolean, locationTypes?: Array<LocationType>, excludeLocationTypes?: Array<LocationType>, isMissing?: boolean, isUnaired?: boolean, minCommunityRating?: number, minCriticRating?: number, minPremiereDate?: string, minDateLastSaved?: string, minDateLastSavedForUser?: string, maxPremiereDate?: string, hasOverview?: boolean, hasImdbId?: boolean, hasTmdbId?: boolean, hasTvdbId?: boolean, isMovie?: boolean, isSeries?: boolean, isNews?: boolean, isKids?: boolean, isSports?: boolean, excludeItemIds?: Array<string>, startIndex?: number, limit?: number, recursive?: boolean, searchTerm?: string, sortOrder?: Array<SortOrder>, parentId?: string, fields?: Array<ItemFields>, excludeItemTypes?: Array<BaseItemKind>, includeItemTypes?: Array<BaseItemKind>, filters?: Array<ItemFilter>, isFavorite?: boolean, mediaTypes?: Array<MediaType>, imageTypes?: Array<ImageType>, sortBy?: Array<ItemSortBy>, isPlayed?: boolean, genres?: Array<string>, officialRatings?: Array<string>, tags?: Array<string>, years?: Array<number>, enableUserData?: boolean, imageTypeLimit?: number, enableImageTypes?: Array<ImageType>, person?: string, personIds?: Array<string>, personTypes?: Array<string>, studios?: Array<string>, artists?: Array<string>, excludeArtistIds?: Array<string>, artistIds?: Array<string>, albumArtistIds?: Array<string>, contributingArtistIds?: Array<string>, albums?: Array<string>, albumIds?: Array<string>, ids?: Array<string>, videoTypes?: Array<VideoType>, minOfficialRating?: string, isLocked?: boolean, isPlaceHolder?: boolean, hasOfficialRating?: boolean, collapseBoxSetItems?: boolean, minWidth?: number, minHeight?: number, maxWidth?: number, maxHeight?: number, is3D?: boolean, seriesStatus?: Array<SeriesStatus>, nameStartsWithOrGreater?: string, nameStartsWith?: string, nameLessThan?: string, studioIds?: Array<string>, genreIds?: Array<string>, enableTotalRecordCount?: boolean, enableImages?: boolean, options?: RawAxiosRequestConfig): Promise<(axios?: AxiosInstance, basePath?: string) => AxiosPromise<BaseItemDtoQueryResult>> {
            const localVarAxiosArgs = await localVarAxiosParamCreator.getItems(userId, maxOfficialRating, hasThemeSong, hasThemeVideo, hasSubtitles, hasSpecialFeature, hasTrailer, adjacentTo, indexNumber, parentIndexNumber, hasParentalRating, isHd, is4K, locationTypes, excludeLocationTypes, isMissing, isUnaired, minCommunityRating, minCriticRating, minPremiereDate, minDateLastSaved, minDateLastSavedForUser, maxPremiereDate, hasOverview, hasImdbId, hasTmdbId, hasTvdbId, isMovie, isSeries, isNews, isKids, isSports, excludeItemIds, startIndex, limit, recursive, searchTerm, sortOrder, parentId, fields, excludeItemTypes, includeItemTypes, filters, isFavorite, mediaTypes, imageTypes, sortBy, isPlayed, genres, officialRatings, tags, years, enableUserData, imageTypeLimit, enableImageTypes, person, personIds, personTypes, studios, artists, excludeArtistIds, artistIds, albumArtistIds, contributingArtistIds, albums, albumIds, ids, videoTypes, minOfficialRating, isLocked, isPlaceHolder, hasOfficialRating, collapseBoxSetItems, minWidth, minHeight, maxWidth, maxHeight, is3D, seriesStatus, nameStartsWithOrGreater, nameStartsWith, nameLessThan, studioIds, genreIds, enableTotalRecordCount, enableImages, options);
            const localVarOperationServerIndex = configuration?.serverIndex ?? 0;
            const localVarOperationServerBasePath = operationServerMap['UserItemsApi.getItems']?.[localVarOperationServerIndex]?.url;
            return (axios, basePath) => createRequestFunction(localVarAxiosArgs, globalAxios, BASE_PATH, configuration)(axios, localVarOperationServerBasePath || basePath);
        },
    }
}