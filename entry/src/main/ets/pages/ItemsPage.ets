import { LoadingDialog, PersistenceV2 } from "@kit.ArkUI";
import { AxiosResponse } from "@ohos/axios";
import { DeviceUtil, LogUtil, ToastUtil } from "@pura/harmony-utils";
import { Api,
    BaseItemDto,
    BaseItemDtoQueryResult,
    getImageApi,
    getUserLibraryApi,
    ItemSortBy,
    SortOrder
} from "@weboose/jellyfin-sdk-arkts";
import { ClientUtil } from "../utils/ClientUtil";
import { OptionsViewModel } from "../viewmodel/OptionsViewModel";
import { ValueType } from "@kit.ArkData";
import { getUserItemsApi } from "../lib/get-user-items-api.ts";
import { SupportSorts } from "../lib/support-sorts";

interface RouteParam {
    id?: string;
}

type QueryOptions = Record<string, ValueType | string[]>;

@ComponentV2
export struct ItemsPage
{
    @Local itemId: string = '';
    @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
    private loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });
    private viewModel:OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    private api?: Api;
    @Local itemInfo: BaseItemDto|null = null;
    @Local result: BaseItemDtoQueryResult|null = null;

    // 分页
    @Local page: number = 1;
    @Local totalPages: number = 1;
    @Local startIndex: number = 0;
    @Local limit: number = 100;

    // 支持的排序
    @Local sortBy: ItemSortBy = 'SortName';
    @Local currentSortIndex: number = 0;
    @Local sortOrder: SortOrder = 'Ascending';

    aboutToAppear(): void {
        const params = this.pageInfos.getParamByName('items') as RouteParam[];
        const param = params[0] || null;
        if(param.id){
            this.api = ClientUtil.createApi({
                deviceName: DeviceUtil.getMarketName(),
                deviceId: this.viewModel.deviceId,
                accessToken: this.viewModel.accessToken,
                server: this.viewModel.server,
                serverVersion: this.viewModel.serverVersion
            });

            this.itemId = param.id;
            this.loadItemInfo();
            this.loadItems();
        }
    }

    async loadItems()
    {
        try{
            this.loading.open();

            const options: QueryOptions = {
                "parentId": this.itemId,
                "userId": this.viewModel.userId,
                "startIndex": String((this.page - 1) * this.limit),
                "limit": String(this.limit),
                "imageTypeLimit": "1",
                "enableImageTypes": ['Primary', "Backdrop","Banner","Thumb"],
                "includeItemTypes": ['Movie'],
                "sortOrder": [this.sortOrder],
                "sortBy": [SupportSorts[this.currentSortIndex].value, 'SortName', 'ProductionYear'],
                "fields": ['PrimaryImageAspectRatio','MediaSourceCount'],
                "recursive": "true"
            };

            const queryResult: AxiosResponse<BaseItemDtoQueryResult> = await getUserItemsApi(this.api).getItems(options);
            if(queryResult.status !== 200){
                throw new Error("获取列表失败");
            }
            this.result = queryResult.data;
            // 计算总数
            if(queryResult.data.TotalRecordCount){
                this.totalPages = Math.ceil(queryResult.data.TotalRecordCount / this.limit);
            }
        }catch (e) {
            ToastUtil.showToast(`${e?.message}`);
            LogUtil.error(e);
        }finally {
            this.loading.close();
        }
    }

    async loadItemInfo()
    {
        try {
            this.loading.open();
            // 读取媒体库
            const itemInfo: AxiosResponse<BaseItemDto> = await getUserItemsApi(this.api)
                .getItem({
                    itemId: this.itemId,
                    userId: this.viewModel.userId
                });

            if(itemInfo.status !== 200){
                throw new Error("获取item信息失败");
            }
            this.itemInfo = itemInfo.data;
            LogUtil.info('itemInfo', JSON.stringify(itemInfo.data));

        }catch(e){
            LogUtil.error("load item info error: ", e);
            ToastUtil.showToast(`${e?.message}`);
        }finally {
            this.loading.close();
        }
    }

    // toolbar
    @Builder
    private toolbarBuilder(){
        Row({space: 12}){
            if(this.result?.TotalRecordCount && this.result?.TotalRecordCount > 0){
                Text(`${this.result?.TotalRecordCount || 0} 中的 ${(this.result?.StartIndex || 0) + 1} - ${Math.min(this.page * this.limit, this.result?.TotalRecordCount)}`)
                    .fontSize(14);
            }else if(this.result?.TotalRecordCount && this.result?.TotalRecordCount <= 0){
                Text("暂无数据")
            }

            Button("上一页")
                .enabled(this.page > 1)
                .padding(8)
                .onClick(()=>{
                    this.page = this.page - 1;
                    this.loadItems();
                });

            Button("下一页")
                .enabled(this.page < this.totalPages)
                .padding(8)
                .onClick(()=>{
                    this.page = this.page + 1;
                    this.loadItems();
                });

            Select(SupportSorts.map<SelectOption>((item) => ({
                icon: item.icon,
                value: item.label
            })))
                .value(SupportSorts[this.currentSortIndex].label)
                .selected($$this.currentSortIndex)
                .onSelect((index) => {
                    this.currentSortIndex = index;
                    this.loadItems();
                });
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
    }

    build() {
        NavDestination(){
            Column({space: 12})
            {
                this.toolbarBuilder();

                Grid()
                {
                    ForEach(this.result?.Items || [], (item: BaseItemDto) => {
                        GridItem()
                        {
                            Column({space: 8})
                            {
                                Image(getImageApi(this.api).getItemImageUrl(item, 'Primary', {
                                    quality: 96,
                                    fillWidth: 213,
                                    fillHeight: 120
                                }))
                                    .width("100%")
                                    .objectFit(ImageFit.Cover)
                                    .aspectRatio(2/3)
                                    .borderRadius(8)
                                    .backgroundColor(Color.Gray)
                                    .shadow(ShadowStyle.OUTER_DEFAULT_XS);

                                Text(item.Name)
                                    .fontSize(14)
                                    .maxLines(1)
                                    .textOverflow({
                                        overflow: TextOverflow.Ellipsis
                                    })
                            }
                            .width("100%")
                        }
                        .onClick(()=>{
                            this.pageInfos.pushPathByName("videoInfo", {
                                id: item.Id
                            }, ()=>{});
                        })
                    })
                }
                .columnsTemplate("1fr 1fr 1fr")
                .columnsGap(12)
                .rowsGap(12)
                .padding(12)
                .width("100%")
                .height("100%")
                .layoutWeight(1)
            }
        }
        .title(this.itemInfo?.Name)
        .width("100%")
        .height("100%")
    }
}

@Builder
export function ItemsBuilder()
{
    ItemsPage();
}