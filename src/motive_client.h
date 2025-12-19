#pragma once

#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"
#include "NatNet/NatNetClient.h"
#include "NatNet/NatNetTypes.h"

using namespace godot;

class MotiveClient : public RefCounted {
	GDCLASS(MotiveClient, RefCounted)

private:
	String server_addr;

protected:
	static void _bind_methods();
	NatNetClient* client;
    sNatNetClientConnectParams params;

public:
	MotiveClient() = default;
	~MotiveClient() override = default;

	void print_config() const;
    void connect_to_motive();
    void timeline_play();
    void disconnect_from_motive();
	void set_server_addr(String);
	String get_server_addr() const;
	
};
