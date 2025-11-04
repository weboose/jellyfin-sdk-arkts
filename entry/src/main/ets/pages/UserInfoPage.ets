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

type QueryOptions = Record<string, string|string[]>;

@ComponentV2
export struct UserInfoPage
{
    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    @Local refreshing: boolean = false;
    loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    @Local currentUser: UserDto | null = null;

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

            const queryResult: AxiosResponse<UserDto> = await getUserApi(this.api)
                .getCurrentUser();

            if(queryResult.status !== 200){
                throw new Error(queryResult.statusText);
            }

            this.currentUser = queryResult.data;

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
        Text(title).fontWeight(FontWeight.Bold);
    }

    build() {
        NavDestination()
        {
            Refresh({
                refreshing: $$this.refreshing
            }){
                List({space: 12}){
                    ListItemGroup({
                        header: this.groupHeaderBuilder("UserInfo")
                    }) {
                        ForEach(Object.entries(this.currentUser || [])
                            .filter((item: [string, ValueType])=>item[0] !== "Configuration" && item[0] !== "Policy"),
                            (item: [string, ValueType])=>{
                                ListItem(){
                                    Column({space: 2}) {
                                        Text(`${item[0]}: `).fontWeight(FontWeight.Bold)
                                            .fontSize(14)
                                        Text(String(item[1]))
                                            .fontSize(14)
                                    }
                                    .width("100%")
                                    .justifyContent(FlexAlign.Start)
                                    .alignItems(HorizontalAlign.Start)
                                }
                            })
                    }

                    ListItemGroup({
                        header: this.groupHeaderBuilder("Configuration")
                    }) {
                        ForEach(Object.entries(this.currentUser?.Configuration || []), (item: [string, ValueType]) => {
                            ListItem() {
                                Column({ space: 2 }) {
                                    Text(`${item[0]}: `).fontWeight(FontWeight.Bold)
                                        .fontSize(14)
                                    Text(String(item[1]))
                                        .fontSize(14)
                                }
                                .width("100%")
                                .justifyContent(FlexAlign.Start)
                                .alignItems(HorizontalAlign.Start)
                            }
                        })
                    }

                    ListItemGroup({
                        header: this.groupHeaderBuilder("Policy")
                    }) {
                        ForEach(Object.entries(this.currentUser?.Policy || []), (item: [string, ValueType]) => {
                            ListItem() {
                                Column({ space: 2 }) {
                                    Text(`${item[0]}: `).fontWeight(FontWeight.Bold)
                                        .fontSize(14)
                                    Text(String(item[1]))
                                        .fontSize(14)
                                }
                                .width("100%")
                                .justifyContent(FlexAlign.Start)
                                .alignItems(HorizontalAlign.Start)
                            }
                        })
                    }
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
export function UserInfoBuilder(){
    UserInfoPage();
}