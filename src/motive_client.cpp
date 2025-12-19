#include "motive_client.h"

void MotiveClient::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("print_config"), &MotiveClient::print_config);
	godot::ClassDB::bind_method(D_METHOD("connect_to_motive"), &MotiveClient::connect_to_motive);
	godot::ClassDB::bind_method(D_METHOD("timeline_play"), &MotiveClient::timeline_play);
	godot::ClassDB::bind_method(D_METHOD("disconnect_from_motive"), &MotiveClient::disconnect_from_motive);

	godot::ClassDB::bind_method(D_METHOD("get_server_addr"), &MotiveClient::get_server_addr);
	godot::ClassDB::bind_method(D_METHOD("set_server_addr", "p_server_addr"), &MotiveClient::set_server_addr);

	ADD_PROPERTY(PropertyInfo(Variant::STRING, "server_addr"), "set_server_addr", "get_server_addr");
}

void MotiveClient::print_config() const {
	print_line("Motive Client Connection Parameters");
	print_line("Local Address: ", params.localAddress);
	print_line("Server Address: ", params.serverAddress);
	if (params.connectionType == ConnectionType_Multicast)
		print_line("Connection Type: Multicast");
	else
		print_line("Connection Type: Unicast");
}


void MotiveClient::connect_to_motive() {
	client = new NatNetClient();
	params.localAddress = "127.0.0.1";
	params.serverAddress = "127.0.0.1";
	params.connectionType = ConnectionType_Multicast;
	client->Connect(params);
}


void MotiveClient::timeline_play() {
	void* response;
	int bytes;
	client->SendMessageAndWait("TimelinePlay", &response, &bytes);
}


void MotiveClient::disconnect_from_motive() {
	client->Disconnect();
}


void MotiveClient::set_server_addr(String p_server_addr) {
	params.serverAddress = "127.0.0.1";
}


String MotiveClient::get_server_addr() const {
	return params.serverAddress;
}