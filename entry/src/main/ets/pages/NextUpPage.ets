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
    getTvShowsApi,
    getUserApi, getUserViewsApi,
    ItemsApiGetResumeItemsRequest } from "@weboose/jellyfin-sdk-arkts";
import { AxiosResponse } from "@ohos/axios";

type QueryOptions = Record<string, string|string[]>;

@ComponentV2
export struct NextUpPage
{
    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    @Local refreshing: boolean = false;
    loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    @Local items: BaseItemDto[] = [];

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

            // fetch resumes
            const options:QueryOptions = {
                "userId": this.viewModel.userId,
                "limit": "12",
                "ImageTypeLimit": "1",
                "enableImageTypes": ['Primary', "Backdrop", "Banner", "Thumb"],
                "mediaTypes": ['Video'],
                "fields": ["PrimaryImageAspectRatio","DateCreated","BasicSyncInfo","Path","MediaSourceCount"]
            };

            const queryResult: AxiosResponse<BaseItemDtoQueryResult> = await getTvShowsApi(this.api)
                .getNextUp(options);

            if(queryResult.status !== 200){
                throw new Error(queryResult.statusText);
            }

            this.items = queryResult.data.Items || [];

        }catch (e) {
            LogUtil.error(e);
            ToastUtil.showToast(`${e?.message}`);
        }finally {
            this.loading.close();
        }
    }

    build() {
        NavDestination()
        {
            Refresh({
                refreshing: $$this.refreshing
            }){
                Grid()
                {
                    ForEach(this.items, (item: BaseItemDto) => {
                        GridItem()
                        {
                            Column({space: 8}){
                                Image(getImageApi(this.api).getItemImageUrl(item, "Primary", {
                                    quality: 96,
                                    fillWidth: 335,
                                    fillHeight: 200
                                }))
                                    .width("100%")
                                    .aspectRatio(16/9)
                                    .backgroundColor(Color.Gray)
                                    .borderRadius(8)
                                    .shadow(ShadowStyle.OUTER_DEFAULT_XS);

                                Text(item.Name)
                                    .ellipsisMode(EllipsisMode.START)
                                    .maxLines(1)
                                    .fontSize(12)
                                    .textOverflow({
                                        overflow: TextOverflow.Ellipsis
                                    })
                                ;
                            }
                            .width("100%")
                        }
                    })
                }
                .columnsTemplate("1fr 1fr")
                .columnsGap(12)
                .rowsGap(12)
                .width("100%")
                .height("100%")
                .padding(12)
            }
        }
        .title("接下来")
        .width("100%")
        .height("100%")
    }
}

@Builder
export function NextUpBuilder(){
    NextUpPage();
}