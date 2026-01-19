#pragma once

#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "NatNet/NatNetClient.h"
#include "NatNet/NatNetTypes.h"
#include "NatNet/NatNetCAPI.h"

using namespace godot;

class MotiveClient : public Node {
	GDCLASS(MotiveClient, Node)

protected:
	static void _bind_methods();

	bool connected;
	bool print_get_data_error;
	NatNetClient* client;
    sNatNetClientConnectParams params;
	sFrameOfMocapData* frame;
	sDataDescriptions* data_descriptions;

	String client_address;
	
	Dictionary rigid_body_assets;

public:
	MotiveClient();
	~MotiveClient();

	void _enter_tree() override;
	void _exit_tree() override;

	bool is_connected();

	void print_config();
    void connect_to_motive();
    void disconnect_from_motive();
    void timeline_play();
	void timeline_stop();

	void set_server_addr(String);
	String get_server_addr() const;
	void set_client_address(String);
	String get_client_address() const;

	Dictionary get_connection_settings();
	void configure_connection_settings(Dictionary);

	Dictionary get_rigid_body_assets();

	Vector3 get_rigid_body_pos(int);
	Quaternion get_rigid_body_rot(int);

	friend void NATNET_CALLCONV DataHandler(sFrameOfMocapData* data, void* pUserData);    // receives data from the server
	
};
