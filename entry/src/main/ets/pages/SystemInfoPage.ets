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
    SystemInfo} from "@weboose/jellyfin-sdk-arkts";
import { AxiosResponse } from "@ohos/axios";
import { ValueType } from "@kit.ArkData";

type QueryOptions = Record<string, string|string[]>;

@ComponentV2
export struct SystemInfoPage
{
    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    @Local refreshing: boolean = false;
    loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    @Local systemInfo: SystemInfo | null = null;

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

            const queryResult: AxiosResponse<SystemInfo> = await getSystemApi(this.api)
                .getSystemInfo();

            if(queryResult.status !== 200){
                throw new Error(queryResult.statusText);
            }

            this.systemInfo = queryResult.data;

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
                List({space: 12}){
                    ForEach(Object.entries(this.systemInfo || []), (item: [string, ValueType])=>{
                        ListItem(){
                            Column({space: 2}) {
                                Text(`${item[0]}: `).fontWeight(FontWeight.Bold)
                                Text(String(item[1]))
                            }
                            .width("100%")
                            .justifyContent(FlexAlign.Start)
                            .alignItems(HorizontalAlign.Start)
                        }
                    })
                }
                .width("100%")
                .height("100%")
                .padding(24)
            }
        }
        .title("系统信息")
        .width("100%")
        .height("100%")
    }
}

@Builder
export function SystemInfoBuilder(){
    SystemInfoPage();
}