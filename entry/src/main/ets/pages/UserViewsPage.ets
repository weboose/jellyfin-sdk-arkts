@ComponentV2
export struct UserViewsPage
{
    build() {
        Text("我的媒体库")
    }
}

@Builder
export function UserViewsBuilder(){
    UserViewsPage();
}