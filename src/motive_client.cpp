#include "motive_client.h"
#include "NatNet/NatNetCAPI.h"



void MotiveClient::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("print_config"), &MotiveClient::print_config);
	godot::ClassDB::bind_method(D_METHOD("connect_to_motive"), &MotiveClient::connect_to_motive);
	godot::ClassDB::bind_method(D_METHOD("disconnect_from_motive"), &MotiveClient::disconnect_from_motive);
	godot::ClassDB::bind_method(D_METHOD("timeline_play"), &MotiveClient::timeline_play);
	godot::ClassDB::bind_method(D_METHOD("timeline_stop"), &MotiveClient::timeline_stop);

	godot::ClassDB::bind_method(D_METHOD("get_server_addr"), &MotiveClient::get_server_addr);
	godot::ClassDB::bind_method(D_METHOD("set_server_addr", "p_server_addr"), &MotiveClient::set_server_addr);

	godot::ClassDB::bind_method(D_METHOD("get_data_descriptions"), &MotiveClient::get_data_descriptions);
	godot::ClassDB::bind_method(D_METHOD("get_rigid_body_pos", "index"), &MotiveClient::get_rigid_body_pos);
	godot::ClassDB::bind_method(D_METHOD("get_rigid_body_rot", "index"), &MotiveClient::get_rigid_body_rot);

	//ADD_PROPERTY(PropertyInfo(Variant::STRING, "server_addr"), "set_server_addr", "get_server_addr");
}


MotiveClient::MotiveClient() {
	client = new NatNetClient();
	frame = NULL;
	connected = false;
	params.localAddress = "127.0.0.1";
	params.serverAddress = "127.0.0.1";
	params.connectionType = ConnectionType_Multicast;

	client->SetFrameReceivedCallback(DataHandler, this);
}


MotiveClient::~MotiveClient() {
	if (client) {
		client->Disconnect();
		delete client;
	}
	if (frame) {
		NatNet_FreeFrame(frame);
		delete frame;
	}
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
	if (connected) {
		print_line("Already connected to Motive");
	}
	else {
		ErrorCode result = client->Connect(params);
		if (result == ErrorCode_OK) {
			print_line("Connected to Motive");
			connected = true;
		}
		else {
			connected = false;
			print_error("Unable to connect to Motive");
		}
	}
}


void MotiveClient::disconnect_from_motive() {
	if (connected) {
		ErrorCode result = client->Disconnect();
		if (result == ErrorCode_OK) {
			print_line("Disconnected from Motive");
			connected = false;
		}	
	}
	else {
		print_line("No connection to disconnect");
	}
	
}



void MotiveClient::timeline_play() {
	void* response;
	int bytes;
	client->SendMessageAndWait("TimelinePlay", &response, &bytes);
}


void MotiveClient::timeline_stop() {
	void* response;
	int bytes;
	client->SendMessageAndWait("TimelineStop", &response, &bytes);
}


void MotiveClient::set_server_addr(String p_server_addr) {
	params.serverAddress = "127.0.0.1";
}


String MotiveClient::get_server_addr() const {
	return params.serverAddress;
}



void MotiveClient::get_data_descriptions() {
	client->GetDataDescriptionList(&data_descriptions);

}


Vector3 MotiveClient::get_rigid_body_pos(int index) {
	if (frame != NULL && index < frame->nRigidBodies) {
		return Vector3(frame->RigidBodies[index].x, 
		               frame->RigidBodies[index].y,
					   frame->RigidBodies[index].z
		);
	}
	else {
		print_line("problem retrieving position data");
		return Vector3(0,0,0);
	}
}


Quaternion MotiveClient::get_rigid_body_rot(int index) {
	if (frame != NULL && index < frame->nRigidBodies) {
		return Quaternion(frame->RigidBodies[index].qx, 
		               frame->RigidBodies[index].qy,
					   frame->RigidBodies[index].qz,
					   frame->RigidBodies[index].qw
		);
	}
	else {
		print_line("problem retrieving rotation data");
		return Quaternion(0,0,0,1);
	}
}

void NATNET_CALLCONV DataHandler(sFrameOfMocapData* data, void* pUserData) {

	MotiveClient* pMotiveClient = (MotiveClient*) pUserData;
	NatNetClient* client = pMotiveClient->client;

    if (!client) {
		print_error("DataHandler error: Bad client pointer");
        return;
	}

    // Note : This function is called every 1 / mocap rate ( e.g. 100 fps = every 10 msecs )
    // We don't want to do too much here and cause the network processing thread to get behind,
    
    // Note : The 'data' ptr passed in is managed by NatNet and cannot be used outside this function.
    // Since we are keeping the data, we need to make a copy of it.
	if (pMotiveClient->frame == NULL) {
		pMotiveClient->frame = new sFrameOfMocapData();
	}
	else {
		NatNet_FreeFrame(pMotiveClient->frame);
	}
	NatNet_CopyFrame(data, pMotiveClient->frame);
}