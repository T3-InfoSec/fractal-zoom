interface Window {
    SendToFlutter:any;
    _flutterMessages: any[];
    sendToFlutter: (message: any) => void;
    getFlutterMessages: () => string;
    receiveFromFlutter: (message: string) => void;
}