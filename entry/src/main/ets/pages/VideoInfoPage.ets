import { OptionsViewModel } from "../viewmodel/OptionsViewModel";
import { AppStorageV2, BorderRadiusMode, LoadingDialog, PersistenceV2 } from "@kit.ArkUI";
import { DeviceUtil, LogUtil, ToastUtil } from "@pura/harmony-utils";
import { Api, BaseItemDto, BaseItemPerson, getImageApi, getUserLibraryApi } from "@weboose/jellyfin-sdk-arkts";
import { ClientUtil } from "../utils/ClientUtil";
import { AxiosResponse } from "@ohos/axios";
import { getUserItemsApi } from "../lib/get-user-items-api.ts";

interface RouteParam {
    id?: string;
}

@ComponentV2
export struct VideoInfoPage
{
    private api: Api|null = null;
    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    @Local itemId: string = '';
    @Local scrollY: number = 0;
    @Local titleBarColor: string = 'transparent';
    @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
    private loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    @Local videoInfo: BaseItemDto|null = null;

    aboutToAppear(): void {
        try{
            const params = this.pageInfos.getParamByName('videoInfo') as RouteParam[];
            const param = params[0] || null;
            if(param?.id){
                this.itemId = param.id;
                this.loadData();
            }
        }catch (e) {
            LogUtil.error(e);
        }
    }

    private async loadData()
    {
        try {
            this.loading.open();
            this.api = ClientUtil.createApi({
                accessToken: this.viewModel.accessToken,
                deviceId: this.viewModel.deviceId,
                deviceName: DeviceUtil.getMarketName(),
                server: this.viewModel.server,
                serverVersion: this.viewModel.serverVersion
            });

            // 获取信息
            const result:AxiosResponse<BaseItemDto> = await getUserItemsApi(this.api).getItem({
                itemId: this.itemId,
                userId: this.viewModel.userId
            });
            if(result.status !== 200){
                throw new Error('读取数据失败');
            }

            this.videoInfo = result.data;
            LogUtil.info('videoInfo: ', JSON.stringify(result.data));
        }catch (e) {
            ToastUtil.showToast(`读取数据错误: ${e?.message}`);
            LogUtil.error(e);
        }finally {
            this.loading.close();
        }
    }

    build() {
        NavDestination()
        {
            Stack()
            {
                this.toolbarBuilder();
                this.contentBuilder();
            }
            .width("100%")
            .height("100%")
            .alignContent(Alignment.TopStart)
            .align(Alignment.TopStart)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
        }
        .width("100%")
        .height("100%")
        .hideTitleBar(true)
        .systemBarStyle({
            statusBarContentColor: this.scrollY < 50 ? Color.White.toString() : Color.Black.toString()
        })
    }

    @Builder
    private contentBuilder(){
        Scroll(){
            Column({space: 0})
            {
                Image(getImageApi(this.api).getItemImageUrl(this.videoInfo, "Backdrop", {
                    fillWidth: 690,
                    fillHeight: 480,
                    quality: 96
                }))
                    .backgroundColor(Color.Black)
                    .width("100%")
                    .aspectRatio(4/3)
                    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

                Column({space: 6}){
                    Text(this.videoInfo?.Name)
                        .maxLines(3)
                        .textOverflow({
                            overflow: TextOverflow.Ellipsis
                        })
                        .fontWeight(FontWeight.Bold)
                        .fontSize(20)

                    Row({space: 12})
                    {
                        Row({space: 4})
                        {
                            Image($r('app.media.ic_star_solid'))
                                .width(16)
                                .height(16)
                                .fillColor(Color.Gray)
                            Text(String(this.videoInfo?.CommunityRating || 0))
                                .fontSize(14)
                        }

                        Row({space: 4}){
                            Text(this.formatVideoDuration(this.videoInfo?.RunTimeTicks || undefined))
                                .fontSize(14);
                            if(this.videoInfo?.MediaStreams && this.videoInfo?.MediaStreams?.length > 0){
                                Text(this.videoInfo.MediaStreams[0].DisplayTitle)
                                    .fontSize(14);
                            }
                        }
                    }

                    if(this.videoInfo?.Genres){
                        Text(this.videoInfo.Genres.join(", "))
                            .fontSize(14)
                    }

                    // 设置说明
                    if(this.videoInfo?.Overview){
                        Column(){
                            Row({space: 12}){
                                Text('简介')
                                    .fontWeight(FontWeight.Bold)
                            }
                            .width("100%")
                            .justifyContent(FlexAlign.SpaceBetween)

                            Text(this.videoInfo?.Overview)
                                .fontSize(14)
                        }
                    }

                    // 演员表
                    if(this.videoInfo?.People){
                        Scroll()
                        {
                            Row({space:12})
                            {
                                ForEach(this.videoInfo?.People, (item: BaseItemPerson) => {
                                    Column({space: 4}){
                                        Text().backgroundColor(Color.Gray)
                                            .width(64)
                                            .height(64)
                                            .borderRadius(9999)

                                        Text(item.Name)
                                            .fontSize(12)
                                            .maxLines(3)
                                            .align(Alignment.Center)
                                            .textAlign(TextAlign.Center)

                                        if(item.Type === 'Actor'){
                                            Text(`饰演: ${item.Role}`)
                                                .fontSize(12)
                                                .fontColor(Color.Grey)
                                                .align(Alignment.Center)
                                                .textAlign(TextAlign.Center)
                                        }else{
                                            Text(`${item.Role}`)
                                                .fontSize(12)
                                                .fontColor(Color.Grey)
                                                .align(Alignment.Center)
                                                .textAlign(TextAlign.Center)
                                        }

                                    }
                                    .width(64)
                                    .alignItems(HorizontalAlign.Center)
                                    .justifyContent(FlexAlign.Center)
                                })
                            }
                            .alignItems(VerticalAlign.Top)
                            .justifyContent(FlexAlign.Start)
                        }
                        .width("100%")
                        .scrollable(ScrollDirection.Horizontal)
                        .nestedScroll({
                            scrollForward: NestedScrollMode.SELF_FIRST,
                            scrollBackward: NestedScrollMode.SELF_FIRST
                        })
                    }

                    Column(){}
                }
                .width("100%")
                .padding(12)
                .margin({top: -24})
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Start)
            }
            .width("100%")
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Start)
            .alignSelf(ItemAlign.Start)
        }
        .width("100%")
        .height("100%")
        .onScroll((xOffset: number, yOffset: number) => {
            this.scrollY = yOffset;
            let alpha = Math.min(1, this.scrollY / 100);
            this.titleBarColor = `rgba(255, 255, 255, ${alpha})`;
        })
        .align(Alignment.TopStart)
        .alignSelf(ItemAlign.Start)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    }

    private formatVideoDuration(runTimeTicks?: number) {
        const ticks = runTimeTicks;
        if (!ticks) return "时长未知";

        const totalSeconds = ticks / 10000000;
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);

        if (hours > 0) {
            return `${hours}小时${minutes}分钟`;
        } else {
            return `${minutes}分钟`;
        }
    }

    @Builder
    private toolbarBuilder()
    {
        Row({space: 12})
        {
            Row({space: 6})
            {
                Button(){
                    Image($r('sys.media.ohos_ic_compnent_titlebar_back'))
                        .width(24)
                        .height(24)
                }
                .onClick(()=>{
                    this.pageInfos.pop();
                })
                .padding(6)
                .backgroundColor('#86ffffff')
                .borderRadius(9999)

                if(this.scrollY > 50){
                    Text(this.videoInfo?.Name)
                        .maxLines(1)
                        .textOverflow({
                            overflow: TextOverflow.Ellipsis
                        })
                }
            }
            .width("100%")
            .layoutWeight(1)
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Start)

            Button(){
                Image($r('sys.media.ohos_ic_public_more'))
                    .width(24)
                    .height(24)
            }
            .padding(6)
            .backgroundColor('#86ffffff')
            .borderRadius(9999)
        }
        .width("100%")
        .zIndex(10)
        .padding(12)
        .backgroundColor(this.titleBarColor)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
    }
}

@Builder
export function VideoInfoBuilder()
{
    VideoInfoPage();
}