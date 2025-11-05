import { Api, BaseItemDto, BaseItemDtoQueryResult, getImageApi, getUserViewsApi } from "@weboose/jellyfin-sdk-arkts"
import { AppStorageV2, LoadingDialog, PersistenceV2 } from "@kit.ArkUI";
import { OptionsViewModel } from "../viewmodel/OptionsViewModel";
import { ClientUtil } from "../utils/ClientUtil";
import { AxiosResponse } from "@ohos/axios";
import { LogUtil, ToastUtil } from "@pura/harmony-utils";

@ComponentV2
export struct UserViewsPage
{
    @Local items: BaseItemDto[] = [];
    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    @Local refreshing:boolean = false;
    api: Api|null = null;

    @Consumer('pageInfos') pageInfos:NavPathStack = new NavPathStack();

    aboutToAppear() {
        this.loadData();
    }

    private async loadData(){
        try {
            this.loading.open();
            this.refreshing = true;
            // jellyfin api
            this.api = ClientUtil.createApi({
                server: this.viewModel.server,
                deviceId: this.viewModel.deviceId,
                accessToken: this.viewModel.accessToken,
                serverVersion: this.viewModel.serverVersion
            });

            // get users views
            const queryResult: AxiosResponse<BaseItemDtoQueryResult> = await getUserViewsApi(this.api).getUserViews({
                userId: this.viewModel.userId
            });

            if(queryResult.status === 200){
                this.items = queryResult.data.Items || [];
            }

        }catch (e) {
            LogUtil.error(e);
            ToastUtil.showToast(`获取数据失败: ${e?.message}`);
        }finally {
            this.loading.close();
            this.refreshing = false;
        }
    }

    build() {
        NavDestination()
        {
            Refresh({
                refreshing: $$this.refreshing
            }){
                List({space: 12})
                {
                    ForEach(this.items, (item:BaseItemDto) => {
                        ListItem(){
                            Row({space: 12}){
                                Image(getImageApi(this.api).getItemImageUrl(item, 'Primary', {
                                    quality: 96,
                                    fillWidth: 335,
                                    fillHeight: 200
                                }))
                                    .backgroundColor('#eee')
                                    .width(220)
                                    .aspectRatio(16/9)
                                    .borderRadius(8);
                                Text(item.Name);
                            }
                            .width("100%")
                        }
                        .onClick(()=>{
                            this.pageInfos.pushPathByName("items", {
                                id: item.Id
                            }, ()=>{
                                LogUtil.info("goto items page")
                            });
                        })
                        .padding(12)
                    })
                }
                .width("100%")
                .height("100%")
            }
            .onRefreshing(()=>{
                this.refreshing = true;
                this.loadData();
            })
        }
        .title("我的媒体库")
    }
}

@Builder
export function UserViewsBuilder(){
    UserViewsPage();
}