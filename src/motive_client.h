//================================================
// Copyright 2026, NaturalPoint Inc. DBA OptiTrack
//================================================

#pragma once

#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "NatNet/NatNetClient.h"
#include "NatNet/NatNetTypes.h"
#include "NatNet/NatNetCAPI.h"

using namespace godot;

void NATNET_CALLCONV DataHandler(sFrameOfMocapData* data, void* pUserData);

class MotiveClient : public Node {
	GDCLASS(MotiveClient, Node)

protected:
	static void _bind_methods();

	bool connected;
	bool rigid_body_data_error;
	bool skeleton_data_error;

	NatNetClient* client;
    sNatNetClientConnectParams params;
	CharString server_address;
	CharString client_address;

	sFrameOfMocapData* frame;
	sDataDescriptions* data_descriptions;
	
	Dictionary rigid_body_assets;
	Dictionary skeleton_assets;

public:
	MotiveClient();
	~MotiveClient();

	bool is_connected_to_motive();

	void print_config();
    void connect_to_motive();
    void disconnect_from_motive();
    void timeline_play();
	void timeline_stop();

	void set_server_address(String);
	String get_server_address() const;
	void set_client_address(String);
	String get_client_address() const;
	void set_multicast(bool);
	bool get_multicast();

	int get_rigid_body_index(int);
	Dictionary get_rigid_body_assets();
	Vector3 get_rigid_body_pos(int);
	Quaternion get_rigid_body_rot(int);

	int get_skeleton_index(int);
	Dictionary get_skeleton_assets();
	Dictionary get_skeleton_bone_data(int);

	friend void NATNET_CALLCONV DataHandler(sFrameOfMocapData* data, void* pUserData);    // receives data from the server
	
};


class BoneData : public RefCounted {
public:
	int bone_id;
	int parent_id;
	Vector3 position;
	Quaternion rotation;
};
