// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class SocketService {
//   final String url;
//   late WebSocketChannel channel;
//
//   SocketService({required this.url});
//
//   void connect() {
//     channel = IOWebSocketChannel.connect(url);
//   }
//
//   void sendMessage(String message) {
//     channel.sink.add(message);
//   }
//
//   Stream get messages => channel.stream;
//
//   void disconnect() {
//     channel.sink.close();
//   }
// }