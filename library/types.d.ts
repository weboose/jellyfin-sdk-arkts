import { asset } from '@kit.AssetStoreKit';
import { url } from '@kit.ArkTS';

declare global {
    type HTMLVideoElement = any;
    var document:any;

    export class URL extends url.URL {}
    export class URLSearchParams extends url.URLSearchParams {}

    interface File {
        readonly name: string;      // 文件名
        readonly lastModified: number; // 最后修改时间戳
        readonly size: number;      // 文件大小（字节）
        readonly type: string;      // MIME 类型
        arrayBuffer(): Promise<ArrayBuffer>;
        slice(start?: number, end?: number): File;
        stream(): any; // 可根据实际需要定义更精确的类型
        text(): Promise<string>;
    }
}

export {};
