//================================================
// Copyright 2026, NaturalPoint Inc. DBA OptiTrack
//================================================

#include "motive_client.h"
#include "NatNet/NatNetCAPI.h"
#include <godot_cpp/classes/engine.hpp>


// This function registers the class's methods with the Godot engine so that 
// they can be accessed in GDScript
void MotiveClient::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("is_connected_to_motive"), &MotiveClient::is_connected_to_motive);
	godot::ClassDB::bind_method(D_METHOD("print_config"), &MotiveClient::print_config);
	godot::ClassDB::bind_method(D_METHOD("connect_to_motive"), &MotiveClient::connect_to_motive);
	godot::ClassDB::bind_method(D_METHOD("disconnect_from_motive"), &MotiveClient::disconnect_from_motive);
	godot::ClassDB::bind_method(D_METHOD("timeline_play"), &MotiveClient::timeline_play);
	godot::ClassDB::bind_method(D_METHOD("timeline_stop"), &MotiveClient::timeline_stop);

	godot::ClassDB::bind_method(D_METHOD("get_server_address"), &MotiveClient::get_server_address);
	godot::ClassDB::bind_method(D_METHOD("set_server_address", "p_server_address"), &MotiveClient::set_server_address);
	godot::ClassDB::bind_method(D_METHOD("get_client_address"), &MotiveClient::get_client_address);
	godot::ClassDB::bind_method(D_METHOD("set_client_address", "p_client_address"), &MotiveClient::set_client_address);
	godot::ClassDB::bind_method(D_METHOD("get_multicast"), &MotiveClient::get_multicast);
	godot::ClassDB::bind_method(D_METHOD("set_multicast", "multicast"), &MotiveClient::set_multicast);

	godot::ClassDB::bind_method(D_METHOD("get_rigid_body_assets"), &MotiveClient::get_rigid_body_assets);
	
	godot::ClassDB::bind_method(D_METHOD("get_rigid_body_pos", "index"), &MotiveClient::get_rigid_body_pos);
	godot::ClassDB::bind_method(D_METHOD("get_rigid_body_rot", "index"), &MotiveClient::get_rigid_body_rot);
}


// Constructor
MotiveClient::MotiveClient() {
	client = new NatNetClient();
	frame = NULL;
	data_descriptions = NULL;
	connected = false;

	// Default connnection parameters
	params.localAddress = "127.0.0.1";
	params.serverAddress = "127.0.0.1";
	params.connectionType = ConnectionType_Multicast;

	client->SetFrameReceivedCallback(DataHandler, this);
}


// Destructor
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


// Get connection status
bool MotiveClient::is_connected_to_motive(){
	return connected;
}


// Prints the connection configuration
void MotiveClient::print_config() {
	print_line("Motive Client Connection Parameters");
	print_line("Local Address: ", params.localAddress);
	print_line("Server Address: ", params.serverAddress);
	if (params.connectionType == ConnectionType_Multicast)
		print_line("Connection Type: Multicast");
	else
		print_line("Connection Type: Unicast");
}


// Attempts to establish a connection with Motive
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


// If connected to Motive, ends the connection
void MotiveClient::disconnect_from_motive() {
	if (connected) {
		ErrorCode result = client->Disconnect();
		if (result == ErrorCode_OK) {
			print_line("Disconnected from Motive");
			connected = false;
		}
		else {
			print_line("Error disconnecting from Motive");
		}
	}
	else {
		print_line("No connection to disconnect");
	}
}


// Sends a the Timeline Play command to the connected Motive server
// Causes the currently loaded take to start/resume playback in Motive
void MotiveClient::timeline_play() {
	void* response;
	int bytes;
	client->SendMessageAndWait("TimelinePlay", &response, &bytes);
}


// Sends a the Timeline Stop command to the connected Motive server
// Causes the currently loaded take to pause playback in Motive
void MotiveClient::timeline_stop() {
	void* response;
	int bytes;
	client->SendMessageAndWait("TimelineStop", &response, &bytes);
}


// Configures the Motive server address.
// Only changes the server address if the string is a valid IP address
// If changed, ends any current connection to Motive
void MotiveClient::set_server_address(String p_server_address) {
	if (p_server_address.is_valid_ip_address()) {
		server_address = p_server_address.ascii();
		params.serverAddress = server_address.get_data();

		if (connected) {
			ErrorCode result = client->Disconnect();
			if (result == ErrorCode_OK) {
				print_line("Disconnected from Motive");
				connected = false;
			}
		}
	}
	else {
		print_line("Not valid IP address. Server address not updated.");
	}
}


// Returns a godot::String of the server IP address as configured in the
// connection parameters
String MotiveClient::get_server_address() const {
	return String(params.serverAddress);
}


// Configures the local IP address.
// Only changes the local address if the string is a valid IP address
// If changed, ends any current connection to Motive
void MotiveClient::set_client_address(String p_client_address) {
	if (p_client_address.is_valid_ip_address()) {
		client_address = p_client_address.ascii();
		params.localAddress = client_address.get_data();

		if (connected) {
			ErrorCode result = client->Disconnect();
			if (result == ErrorCode_OK) {
				print_line("Disconnected from Motive");
				connected = false;
			}
		}
	}
	else {
		print_line("Not valid IP address. Client address not updated.");
	}
}


// Returns a godot::String of the client (local) IP address as configured in the
// connection parameters
String MotiveClient::get_client_address() const {
	return String(params.localAddress);
}


// Configures the connection settings to use multicast or unicast
void MotiveClient::set_multicast(bool multicast) {
	if (multicast) {
		params.connectionType = ConnectionType_Multicast;
		if (connected) {
			ErrorCode result = client->Disconnect();
			if (result == ErrorCode_OK) {
				print_line("Disconnected from Motive");
				connected = false;
			}
		}
	}
	else {
		params.connectionType = ConnectionType_Unicast;
	}
}


// Returns true if the connection parameters are configured for multicast
// Returns false if configured for unicast
bool MotiveClient::get_multicast() {
	if (params.connectionType == ConnectionType_Multicast) {
		return true;
	}
	else {
		return false;
	}
}


// Returns a godot Dictionary of the rigid body assets 
// returns a dictionary where the keys and the values are as follows:
// key (int): streaming ID, value (String): "[asset ID]: [asset name]"
// If the call to GetDataDescriptionList fails (e.g., the client is not connected)
// returns a Dictionary with one key/value pair (0, "Check Motive connection")
Dictionary MotiveClient::get_rigid_body_assets() {
	ErrorCode result = client->GetDataDescriptionList(&data_descriptions);

	rigid_body_assets.clear();
	
	if (result != ErrorCode_OK) {
		rigid_body_assets.set(0, "Check Motive connection");
		return rigid_body_assets;
	}
	else {
		for (int i = 0; i < data_descriptions->nDataDescriptions; i++) {
			if (data_descriptions->arrDataDescriptions[i].type == Descriptor_RigidBody) {
				sRigidBodyDescription* pRB = data_descriptions->arrDataDescriptions[i].Data.RigidBodyDescription;
				String asset_ID_and_name = String::num_int64(pRB->ID) + String(": ") + String(pRB->szName);
				int enitityID, streamingID;
				NatNet_DecodeID(pRB->ID, &enitityID, &streamingID);
				rigid_body_assets.set(streamingID, asset_ID_and_name);
			}
		}
		return rigid_body_assets;
	}
}


// Returns a godot Vector3 containing the position data from the latest frame
// of MoCap data for the rigid body with the streaming ID index.
// If no frame data is available (e.g., a connection has not been esatblished yet)
// returns the zero vector.  Prints an error message once.
Vector3 MotiveClient::get_rigid_body_pos(int index) {
	if (frame != NULL && index < frame->nRigidBodies) {
		print_get_data_error = true;
		return Vector3(frame->RigidBodies[index].x, 
		               frame->RigidBodies[index].y,
					   frame->RigidBodies[index].z
		);
	}
	else {
		if (print_get_data_error) {
			print_line("Couldn't retrieve rigid body data. Check connection to Motive");
			print_get_data_error = false;
		}
		return Vector3(0,0,0);
	}
}


// Returns a godot Quaternion containing the rotation data from the latest frame
// of MoCap data for the rigid body with the streaming ID index.
// If no frame data is available (e.g., a connection has not been esatblished yet)
// returns the identity quaternion.  Prints an error message once.
Quaternion MotiveClient::get_rigid_body_rot(int index) {
	if (frame != NULL && index < frame->nRigidBodies) {
		return Quaternion(frame->RigidBodies[index].qx, 
		               frame->RigidBodies[index].qy,
					   frame->RigidBodies[index].qz,
					   frame->RigidBodies[index].qw
		);
	}
	else {
		return Quaternion(0,0,0,1);
	}
}


// Called every time a new frame of MoCap data is received.
// Saves the data in MotiveClient::frame
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
