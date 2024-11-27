interface Window {
    SendToFlutter:any;
    _flutterMessages: any[];
    sendToFlutter: (message: string) => void;
    getFlutterMessages: () => string;
    receiveFromFlutter: (message: string) => void;
}