import { ConfigInterface } from "../model/JellyfinOptions";

@ObservedV2
export class OptionsViewModel
{
    @Trace server: string = 'http://demo.jellyfin.org/stable';
    @Trace username: string = '';
    @Trace password: string = '';
    @Trace accessToken: string = '';
    @Trace deviceId: string = '';
    @Trace userId: string = '';
    @Trace serverVersion: string = '';
    @Trace serverName: string = '';

    // 检测是否参数有效
    validate(){
        if(!this.server || this.server === ''){
            return false;
        }
        if(!this.username || this.username === ''){
            return false;
        }
        if(!this.password || this.password === ''){
            return false;
        }
        if(!this.serverVersion || this.serverVersion === ''){
            return false;
        }

        return true;
    }

    reset(){
        this.server = "";
        this.username = "";
        this.password = "";
        this.accessToken = "";
        this.deviceId = "";
        this.userId = "";
        this.serverVersion = "";
        this.serverName = "";
    }
}