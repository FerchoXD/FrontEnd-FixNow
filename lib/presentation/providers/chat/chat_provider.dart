import 'package:fixnow/config/config.dart';
import 'package:fixnow/domain/entities/chat_message.dart';
import 'package:fixnow/domain/entities/user.dart';
import 'package:fixnow/infrastructure/datasources/auth_user.dart';
import 'package:fixnow/infrastructure/errors/custom_error.dart';
import 'package:fixnow/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final chatSupplierProvider =
    StateNotifierProvider<ChatProNotifier, ChatProState>((ref) {
  final authState = ref.watch(authProvider);
  final userData = AuthUser();
  return ChatProNotifier(authState: authState, authUser: userData);
});

class ChatProState {
  final List<String> customersNames;
  final List<ChatMessage> messages;
  final bool isConnected;
  final String message;
  final bool isWritingYou;
  final String customerId;
  final String supplierId;
  final List<Map<String, dynamic>> listCustomers;

  ChatProState({
    this.customersNames = const [],
    required this.messages,
    this.isConnected = false,
    this.message = '',
    this.isWritingYou = false,
    this.customerId = '',
    this.supplierId = '',
    this.listCustomers = const [],
  });

  ChatProState copyWith(
          {List<String>? customersNames,
          List<ChatMessage>? messages,
          bool? isConnected,
          String? message,
          bool? isWritingYou,
          String? customerId,
          String? supplierId,
          List<Map<String, dynamic>>? listCustomers}) =>
      ChatProState(
          customersNames: customersNames ?? this.customersNames,
          messages: messages ?? this.messages,
          isConnected: isConnected ?? this.isConnected,
          message: message ?? this.message,
          isWritingYou: isWritingYou ?? this.isWritingYou,
          customerId: customerId ?? this.customerId,
          supplierId: supplierId ?? this.supplierId,
          listCustomers: listCustomers ?? this.listCustomers);
}

class ChatProNotifier extends StateNotifier<ChatProState> {
  late IO.Socket socket;
  final AuthState authState;
  final AuthUser authUser;
  final ScrollController chatScrollController = ScrollController();

  ChatProNotifier({required this.authState, required this.authUser})
      : super(ChatProState(messages: [], isConnected: false)) {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(
      'ws://192.168.172.168:5001',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.on('connect', (_) {
      print('Conectado al servidor');
      state = state.copyWith(isConnected: true);
      socket.emit('register', authState.user!.id);
    });

    socket.on('new_message', (data) async {
      print('Nuevo mensaje de ${data['sender']}: ${data['message']}: ${data['name']}');
      _addCustomerIfNotExists(data['sender'], data['name']);
      _addMessageOther(data['message']);
    });

    socket.on('error', (data) {
      print(data['message']);
    });

    socket.on('disconnect', (_) {
      print('Desconectado del servidor');
    });
  }

  void _addCustomerIfNotExists(String customerId, String customerName) {
    bool exists = state.listCustomers.any((customer) => customer['id'] == customerId);
    if (!exists) {
      final newCustomer = {'id': customerId, 'name': customerName};
      state = state.copyWith(
        listCustomers: [...state.listCustomers, newCustomer],
      );
    }
  }

  sendMessage(String message, String clientId, String supplierId) {
    if (message.isEmpty) return;
    final messageData = {
      "sender": supplierId,
      "receiver": clientId,
      "message": message,
      "name": authState.user!.fullname
    };
    socket.emit('send_message', messageData);
    _addMessage(message);
  }

  void _addMessageOther(String message) {
    final newMessage = ChatMessage(text: message, userChat: UserChat.userYou);
    state = state.copyWith(messages: [...state.messages, newMessage]);
  }

  void _addMessage(String message) {
    final newMessage = ChatMessage(text: message, userChat: UserChat.userMe);
    state = state.copyWith(messages: [...state.messages, newMessage]);
  }

  void disconnect() {
    socket.disconnect();
  }
}
