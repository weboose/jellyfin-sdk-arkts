import { AppStorageV2, LoadingDialog, PersistenceV2 } from '@kit.ArkUI'
import { AxiosResponse } from '@ohos/axios';
import { Base64Util, DeviceUtil, LogUtil, StrUtil, ToastUtil } from '@pura/harmony-utils';
import { AuthenticationResult, getSystemApi, getUserApi, Jellyfin } from '@weboose/jellyfin-sdk-arkts';
import { PublicSystemInfo } from '@weboose/jellyfin-sdk-arkts/src/main/ets/generated-client/models';
import { ClientUtil } from '../utils/ClientUtil';
import { OptionsViewModel } from '../viewmodel/OptionsViewModel';

interface OptionValues {
    server: string;
    username: string;
    password: string;
}

@Entry
@ComponentV2
struct Index {

    private viewModel: OptionsViewModel = PersistenceV2.connect(OptionsViewModel, ()=>new OptionsViewModel())!;
    @Provider('pageInfos') pageInfos: NavPathStack = new NavPathStack();

    @Local values:OptionValues = {
        server: this.viewModel.server,
        username: this.viewModel.username,
        password: this.viewModel.password
    };

    private loading: CustomDialogController = new CustomDialogController({
        builder: LoadingDialog({
            content: "请稍后..."
        }),
        alignment: DialogAlignment.Center
    });

    aboutToAppear(): void {
    }

    build() {
        Navigation(this.pageInfos){
                Column({space: 12}){
                    if(this.viewModel.validate()){
                        this.testMenuBuilder();
                    }else{
                        this.optionsBuilder();
                    }
                }
                .backgroundColor("#eee")
                .padding(24)
                .width("100%")
                .height("100%")
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
        }
        .width("100%")
        .height("100%")
        .toolbarConfiguration([
            {
                icon: $r('sys.media.return_home_fill'),
                value: "首页"
            },
            {
                icon: $r('sys.media.ohos_user_auth_icon_fingerprint'),
                value: "设置"
            }
        ])
    }

    private async checkOptions(){
        if(this.viewModel.validate()){
            ToastUtil.showToast("参数填写不正确");
            return;
        }
        try{
            this.loading.open();
            // 设置deviceId
            const base64Array = await Base64Util.encode(StrUtil.strToUint8Array(`${DeviceUtil.getDeviceId()}-${this.values.username}`));
            const deviceId = StrUtil.unit8ArrayToStr(base64Array);

            // 获取服务器信息
            const api = ClientUtil.createApi({
                server: this.viewModel.server,
                deviceId: deviceId,
                deviceName: DeviceUtil.getMarketName()
            });

            const systemInfo: AxiosResponse<PublicSystemInfo> = await getSystemApi(api).getPublicSystemInfo();
            if(systemInfo.status !== 200){
                throw new Error('无法获取服务器信息');
            }

            // 检测用户账号密码
            const auth: AxiosResponse<AuthenticationResult> = await getUserApi(api).authenticateUserByName({
                authenticateUserByName: {
                    Username: this.viewModel.username,
                    Pw: this.viewModel.password
                }
            });

            if(auth.status !== 200){
                throw new Error("请检查您的账号与密码是否填写正确");
            }

            // 检查通过，保存
            this.viewModel.server = this.values.server;
            this.viewModel.username = this.values.username;
            this.viewModel.password = this.values.password;
            this.viewModel.accessToken = auth.data.AccessToken || "";
            this.viewModel.userId = auth.data.User?.Id || "";
            this.viewModel.serverName = systemInfo.data.ServerName || "";
            this.viewModel.serverVersion = systemInfo.data.Version || "";
            this.viewModel.deviceId = deviceId;

        }catch (e) {
            LogUtil.error(e);
            ToastUtil.showToast(e?.message || "发生错误，请检查日志");
        }finally {
            this.loading.close();
        }
    }

    @Builder
    private optionsBuilder(){
        TextInput({
            text: this.viewModel.server,
            placeholder: "服务器地址"
        }).width("100%").onChange((value) => this.viewModel.server = value);
        TextInput({
            text: this.viewModel.username,
            placeholder: "用户名"
        }).width("100%").onChange((value) => this.viewModel.username = value);
        TextInput({
            text: this.viewModel.password,
            placeholder: "密码"
        }).width("100%").onChange((value) => this.viewModel.password = value);

        Button("确定").width("100%").padding(12).onClick(()=>{
            this.checkOptions();
        });
    }

    @Builder
    private testMenuBuilder(){
        List({space: 4}){
            ListItem(){
                Row(){
                    Text("服务器地址: ")
                    Text(this.viewModel.server)
                }
                .width("100%")
            }
            ListItem(){
                Row(){
                    Text("服务器名称: ")
                    Text(this.viewModel.serverName)
                }
                .width("100%")
            }
            ListItem(){
                Row(){
                    Text("服务器版本: ")
                    Text(this.viewModel.serverVersion)
                }
                .width("100%")
            }
            ListItem(){
                Row(){
                    Text("客户端ID: ")
                    Text(this.viewModel.deviceId)
                }
                .width("100%")
            }
        }
        .width("100%")
        .padding(12)
        .borderWidth(1)
        .borderRadius(8)
        .borderColor(Color.Gray)
        .borderStyle(BorderStyle.Solid)

        Menu()
        {
            MenuItem({
                content: "读取用户媒体库"
            }).onClick(()=>this.pageInfos.replacePathByName("userViews", {}));

            MenuItem({
                content: "读取用户播放记录"
            }).onClick(()=>this.pageInfos.replacePathByName("userResumes", {}));
            MenuItem({
                content: "读取接下来观看"
            }).onClick(()=>this.pageInfos.replacePathByName("nextUp", {}))
            MenuItem({
                content: "读取系统信息"
            }).onClick(()=>this.pageInfos.replacePathByName("systemInfo", {}))
            MenuItem({
                content: "读取用户信息"
            }).onClick(()=>this.pageInfos.replacePathByName("userInfo", {}))
            MenuItem({
                content: "读取用户收藏"
            }).onClick(()=>this.pageInfos.replacePathByName("favorites", {}))
            MenuItem({
                content: "重置服务器信息"
            }).onClick(()=>{
                this.viewModel.reset();
            })
        }
        .width("100%")
        .backgroundColor(Color.White)
    }
}