@ComponentV2
export struct UserResumesPage
{
    build() {
        Text("我的媒体库")
    }
}

@Builder
export function UserResumesBuilder(){
    UserResumesPage();
}