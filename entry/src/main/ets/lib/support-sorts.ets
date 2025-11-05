import { ItemSortBy, SortOrder } from "@weboose/jellyfin-sdk-arkts";

export interface SelectValueOption
{
    icon?: ResourceStr;
    label: ResourceStr;
    value: ItemSortBy;
}

export interface SortDirection
{
    icon?: ResourceStr;
    label: ResourceStr;
    value: SortOrder;
}

export const SupportSorts: SelectValueOption[] = [
    {
        label: "名称",
        value: 'Name'
    },
    {
        label: 'IMDB评分',
        value: 'CommunityRating'
    },
    {
        label: '影评人评分',
        value: 'CriticRating'
    },
    {
        label: '加入日期',
        value: 'DateCreated'
    },
    {
        label: '播放日期',
        value: 'DatePlayed'
    },
    {
        label: '家长分级',
        value: 'OfficialRating'
    },
    {
        label: '播放次数',
        value: 'PlayCount'
    },
    {
        label: '发行日期',
        value: 'PremiereDate'
    },
    {
        label: '播放时常',
        value: 'Runtime'
    }
];

export const SupportSortOrder: SortDirection[] = [
    {
        label: "升序",
        value: 'Ascending'
    },
    {
        label: '降序',
        value: 'Descending'
    }
];