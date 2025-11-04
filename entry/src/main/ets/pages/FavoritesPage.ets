import { OptionsViewModel } from "../viewmodel/OptionsViewModel";
import { LoadingDialog, PersistenceV2 } from "@kit.ArkUI";
import { DeviceUtil, LogUtil, ToastUtil } from "@pura/harmony-utils";
import { ClientUtil } from "../utils/ClientUtil";
import {
    Api,
    BaseItemDto,
    BaseItemDtoQueryResult,
    getImageApi,
    getItemsApi,
    getSystemApi,
    getTvShowsApi,
    getUserApi, getUserViewsApi,
    ItemsApiGetResumeItemsRequest,
    SystemInfo,
    UserDto} from "@weboose/jellyfin-sdk-arkts";
import { AxiosResponse } from "@ohos/axios";
import { ValueType } from "@kit.ArkData";

type QueryOptions = Record<string, string|number|boolean|string[]>;

@ComponentV2
export struct FavoritesPage
{
    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    @Local refreshing: boolean = false;
    loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    @Local result: BaseItemDtoQueryResult | null = null;

    private api: Api|null = null;

    aboutToAppear(): void {
        this.loadData();
    }

    async loadData(){
        try {
            this.loading.open();
            this.api = ClientUtil.createApi({
                server: this.viewModel.server,
                serverVersion: this.viewModel.serverVersion,
                accessToken: this.viewModel.accessToken,
                deviceId: this.viewModel.deviceId,
                deviceName: DeviceUtil.getMarketName()
            });

            const options:QueryOptions = {
                "userId": this.viewModel.userId,
                "limit": "20",
                "sortBy": ['SeriesSortName', 'SortName'],
                "sortOrder": ['Ascending'],
                "filters": ['IsFavorite'],
                "recursive": "true",
                "fields": ['PrimaryImageAspectRatio','EnableMediaSourceDisplay'],
                "collapseBoxSetItems": "false",
                "excludeLocationTypes": ['Virtual'],
                "enableTotalRecordCount": "false",
                "includeItemTypes": ['Movie']
            };

            const queryResult: AxiosResponse<BaseItemDtoQueryResult> = await getItemsApi(this.api)
                .getItems(options);

            if(queryResult.status !== 200){
                throw new Error(queryResult.statusText);
            }

            this.result = queryResult.data;

        }catch (e) {
            LogUtil.error(e);
            ToastUtil.showToast(`${e?.message}`);
        }finally {
            this.loading.close();
        }
    }

    @Builder
    private groupHeaderBuilder(title: string)
    {
        Text(title).fontWeight(FontWeight.Bold).padding(12);
    }

    build() {
        NavDestination()
        {
            Refresh({
                refreshing: $$this.refreshing
            }){
                List(){
                    ListItemGroup({
                        header: this.groupHeaderBuilder('电影')
                    }){
                        ListItem(){
                            List({space: 12})
                            {
                                ForEach(this.result?.Items||[], (item: BaseItemDto) => {
                                    ListItem(){
                                        Column({space: 8}){
                                            Image(getImageApi(this.api).getItemImageUrl(item, "Primary",{
                                                fillWidth: 167,
                                                fillHeight: 223,
                                                quality: 96
                                            }))
                                                .width("100%")
                                                .aspectRatio(2/3)
                                                .borderRadius(8)
                                                .shadow(ShadowStyle.OUTER_DEFAULT_XS)
                                                .backgroundColor(Color.Gray)

                                            Text(item.Name)
                                                .fontSize(14)
                                                .textOverflow({
                                                    overflow: TextOverflow.Ellipsis
                                                })
                                                .maxLines(1)
                                        }
                                        .width(167)
                                    }
                                })
                            }
                            .listDirection(Axis.Horizontal)
                            .width("100%")
                            .scrollBar(BarState.Off)
                        }
                        .padding({top: 8, left: 12, right: 12, bottom: 8})
                    }
                }
                .width("100%")
                .height("100%")
            }
            .width("100%")
            .height("100%")
        }
        .title("我的最爱")
        .width("100%")
        .height("100%")
    }
}

@Builder
export function FavoritesBuilder(){
    FavoritesPage();
}